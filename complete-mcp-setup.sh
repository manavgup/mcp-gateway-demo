#!/bin/bash

# complete-mcp-setup.sh
# Complete setup script for all MCP servers with Context Forge

set -e

# Function to prompt for MCP gateway path
get_mcp_gateway_path() {
    if [ -z "$MCP_GATEWAY_DIR" ]; then
        echo "🔍 Please provide the path to your mcp-context-forge directory:"
        echo "   (Default: /Users/mg/mg-work/manav/work/ai-experiments/mcp-context-forge)"
        read -r input_path
        if [ -z "$input_path" ]; then
            export MCP_GATEWAY_DIR="/Users/mg/mg-work/manav/work/ai-experiments/mcp-context-forge"
        else
            export MCP_GATEWAY_DIR="$input_path"
        fi
    fi
    
    # Verify the directory exists and contains mcpgateway
    if [ ! -d "$MCP_GATEWAY_DIR" ]; then
        echo "❌ Directory not found: $MCP_GATEWAY_DIR"
        exit 1
    fi
    
    if [ ! -d "$MCP_GATEWAY_DIR/mcpgateway" ]; then
        echo "❌ mcpgateway module not found in: $MCP_GATEWAY_DIR"
        echo "   Expected to find: $MCP_GATEWAY_DIR/mcpgateway"
        exit 1
    fi
    
    echo "✅ Found MCP Gateway at: $MCP_GATEWAY_DIR"
}

# Determine gateway URL mode
if [[ "$1" == "--dev-mode" ]]; then
    export MCP_GATEWAY_URL="http://localhost:8000"
    echo "🛠️  Dev mode enabled. Using MCP Gateway URL: $MCP_GATEWAY_URL"
else
    export MCP_GATEWAY_URL="http://localhost:4444"
    echo "🚀 Using production MCP Gateway URL: $MCP_GATEWAY_URL"
fi
echo " MCP_GATEWAY_URL = $MCP_GATEWAY_URL"

# Get MCP gateway path
get_mcp_gateway_path

# Configuration
export GITHUB_TOKEN="${GITHUB_PERSONAL_ACCESS_TOKEN:-your_github_token_here}"
export MEMORY_TOKEN="${MEMORY_PLUGIN_TOKEN:-your_memory_token_here}"
export WORK_DIR="/Users/mg/mg-work"
export DOWNLOADS_DIR="/Users/mg/Downloads"
export DOCUMENTS_DIR="/Users/mg/Documents"

# Set Python path to include the MCP gateway directory
export PYTHONPATH="$MCP_GATEWAY_DIR:$PYTHONPATH"
echo "🐍 Set PYTHONPATH to include: $MCP_GATEWAY_DIR"

# Generate JWT token for MCP gateway authentication
if [ -z "$MCP_BEARER_TOKEN" ]; then
    echo "🔑 Generating JWT token for MCP gateway authentication..."
    cd "$MCP_GATEWAY_DIR"
    export MCP_BEARER_TOKEN=$(python3 -m mcpgateway.utils.create_jwt_token \
          --username admin --exp 10080 --secret my-test-key)
    if [ $? -eq 0 ]; then
        echo "✅ JWT token generated successfully"
    else
        echo "❌ Failed to generate JWT token. Is mcpgateway properly installed?"
        exit 1
    fi
else
    echo "🔑 Using existing MCP_BEARER_TOKEN"
fi

if [ -z "$MEMORY_PLUGIN_TOKEN" ]; then
    export MEMORY_PLUGIN_TOKEN="default-memory-token-for-testing"
    echo "Setting default MEMORY_PLUGIN_TOKEN for testing"
fi

echo "🧹 Cleaning up existing PM2 processes..."
pm2 delete all 2>/dev/null || true

echo "🧹 Cleaning up existing Docker containers..."
docker stop fast-time-server 2>/dev/null || true
docker rm fast-time-server 2>/dev/null || true

echo "🧹 Cleaning up existing gateway server registrations..."
# Only attempt cleanup if we can reach the gateway
if curl -s --max-time 5 "$MCP_GATEWAY_URL/health" >/dev/null 2>&1; then
    curl -s -H "Authorization: Bearer $MCP_BEARER_TOKEN" \
      "$MCP_GATEWAY_URL/gateways" 2>/dev/null | jq -r '.[].id' 2>/dev/null | while read server_id; do
      if [ ! -z "$server_id" ]; then
        echo "Deleting server ID: $server_id"
        curl -X DELETE -H "Authorization: Bearer $MCP_BEARER_TOKEN" \
          "$MCP_GATEWAY_URL/gateways/$server_id" 2>/dev/null || true
      fi
    done
else
    echo "⚠️  Gateway not reachable, skipping cleanup"
fi

echo "🔨 Skipping git server setup..."

echo "🐳 Starting Docker time server..."
docker run --rm -d -p 8899:8080 --name fast-time-server fast-time-server:latest

echo "🔄 Starting translated servers with PM2..."
# Change to MCP gateway directory and start services
cd "$MCP_GATEWAY_DIR"

# Test if mcpgateway.translate works before starting PM2 processes
echo "🧪 Testing mcpgateway.translate module..."
python3 -c "import mcpgateway.translate; print('✅ mcpgateway.translate module accessible')" || {
    echo "❌ Cannot import mcpgateway.translate module"
    echo "   Current directory: $(pwd)"
    echo "   PYTHONPATH: $PYTHONPATH"
    echo "   Please ensure mcpgateway is properly installed or run from the correct directory"
    exit 1
}

pm2 start "python3 -m mcpgateway.translate --stdio 'npx @modelcontextprotocol/server-filesystem $DOWNLOADS_DIR' --port 9000" --name filesystem-downloads --cwd "$MCP_GATEWAY_DIR"
pm2 start "python3 -m mcpgateway.translate --stdio 'npx @modelcontextprotocol/server-filesystem $DOCUMENTS_DIR' --port 9001" --name filesystem-documents --cwd "$MCP_GATEWAY_DIR"
pm2 start "MEMORY_PLUGIN_TOKEN=$MEMORY_PLUGIN_TOKEN python3 -m mcpgateway.translate --stdio 'npx @memoryplugin/mcp-server' --port 9002" --name memory-server --cwd "$MCP_GATEWAY_DIR"
pm2 start "python3 -m mcpgateway.translate --stdio 'docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_TOKEN ghcr.io/github/github-mcp-server stdio' --port 9003" --name github-server --cwd "$MCP_GATEWAY_DIR"

echo "⏳ Waiting for servers to start..."
sleep 10

echo "🔍 Verifying PM2 processes..."
pm2 list
echo

FAILED_PROCESSES=$(pm2 jlist | jq -r '.[] | select(.pm2_env.status != "online") | .name' 2>/dev/null || echo "")
if [ ! -z "$FAILED_PROCESSES" ]; then
    echo "⚠️  Some processes failed to start properly:"
    echo "$FAILED_PROCESSES"
    echo "Checking logs for failed processes..."
    pm2 logs --lines 10
    echo ""
    echo "🔧 Debug info:"
    echo "   MCP_GATEWAY_DIR: $MCP_GATEWAY_DIR"
    echo "   PYTHONPATH: $PYTHONPATH"
    echo "   Current working directory: $(pwd)"
fi

echo "📝 Registering servers with gateway..."
curl -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"name":"filesystem-downloads","url":"http://localhost:9000/sse","description":"Filesystem server for Downloads folder"}' "$MCP_GATEWAY_URL/gateways"
curl -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"name":"filesystem-documents","url":"http://localhost:9001/sse","description":"Filesystem server for Documents folder"}' "$MCP_GATEWAY_URL/gateways"
curl -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"name":"memory-server","url":"http://localhost:9002/sse","description":"Memory plugin server for persistent storage"}' "$MCP_GATEWAY_URL/gateways"
curl -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"name":"github-server","url":"http://localhost:9003/sse","description":"Official GitHub MCP server"}' "$MCP_GATEWAY_URL/gateways"
curl -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"name":"time-server","url":"http://localhost:8899/sse","description":"Time server for timezone operations"}' "$MCP_GATEWAY_URL/gateways"

echo ""
echo "✅ Setup complete! Server status:"
pm2 list

echo ""
echo "🌐 Gateway servers:"
curl -s -H "Authorization: Bearer $MCP_BEARER_TOKEN" "$MCP_GATEWAY_URL/gateways" | jq '.[] | {name: .name, url: .url, enabled: .enabled}' 2>/dev/null || curl -s -H "Authorization: Bearer $MCP_BEARER_TOKEN" "$MCP_GATEWAY_URL/gateways"

echo ""
echo "🔄 Triggering gateway refresh to discover tools..."
sleep 5
curl -s -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1,"method":"ping"}' "$MCP_GATEWAY_URL/rpc" >/dev/null 2>&1 || true

echo ""
echo "🎉 All servers are running! Check the admin UI at $MCP_GATEWAY_URL/admin"
echo ""
echo "📊 Final verification - Available tools:"
curl -s -X POST -H "Authorization: Bearer $MCP_BEARER_TOKEN" -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","id":1,"method":"list_tools"}' "$MCP_GATEWAY_URL/rpc" | jq '.result.tools[].name' 2>/dev/null || echo "Use: curl -X POST -H 'Authorization: Bearer \$MCP_BEARER_TOKEN' -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"list_tools\"}' $MCP_GATEWAY_URL/rpc"

echo ""
echo "📊 Gateway counts:"
curl -s -H "Authorization: Bearer $MCP_BEARER_TOKEN" "$MCP_GATEWAY_URL/gateways" | jq 'length' 2>/dev/null || echo "Could not fetch gateway count"

echo ""
echo "🔧 Troubleshooting tips:"
echo "- If tools show as N/A in the UI, check server logs: pm2 logs"
echo "- Verify servers are responding: curl http://localhost:9000/health"
echo "- Check gateway logs for connection issues"
echo "- Try refreshing the admin UI after a few minutes"
echo "- Ensure mcpgateway is properly installed in: $MCP_GATEWAY_DIR"

pm2 save