#!/bin/bash

# MCP Gateway Demo Runner Script
# Run progressive demos that showcase MCP Gateway capabilities

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Demo configurations
DEMO_NAMES=(
    "Smart Development Workflow"
    "Full GitHub Workflow Automation"
    "Enterprise Development Intelligence"
    "AI Development Team Member"
)

DEMO_TIMES=(
    "5 minutes"
    "10 minutes"
    "15 minutes"
    "20 minutes"
)

DEMO_DIRS=(
    "demo1-smart-workflow"
    "demo2-github-automation"
    "demo3-enterprise-intelligence"
    "demo4-ai-team-member"
)

DEMO_DESCS=(
    "Git Analysis → PR Planning → GitHub Integration"
    "End-to-end GitHub workflow automation"
    "Multi-repo analysis with memory learning"
    "Autonomous AI team member capabilities"
)

# MCP Gateway configuration
MCP_GATEWAY_URL="http://localhost:4444"
MCP_GATEWAY_TOKEN="${MCP_GATEWAY_TOKEN:-eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNzU1ODY3MjA1fQ.tAqbj8_EAOJPo0M3XhtRte9lh3tvFE0sbwMPjKDvGHk}"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if MCP Gateway is running
check_mcp_gateway() {
    print_status $BLUE "🔍 Checking MCP Gateway status..."
    
    if curl -s "${MCP_GATEWAY_URL}/health" > /dev/null 2>&1; then
        print_status $GREEN "✅ MCP Gateway is running on ${MCP_GATEWAY_URL}"
        return 0
    else
        print_status $RED "❌ MCP Gateway is not accessible on ${MCP_GATEWAY_URL}"
        print_status $YELLOW "💡 Make sure MCP Gateway is running:"
        print_status $YELLOW "   • Run: docker-compose up -d"
        print_status $YELLOW "   • Or start manually: mcpgateway --host 0.0.0.0 --port 4444"
        return 1
    fi
}

# Function to check Python dependencies
check_python_deps() {
    print_status $BLUE "🐍 Checking Python dependencies..."
    
    if ! python3 -c "import httpx, rich" 2>/dev/null; then
        print_status $YELLOW "⚠️  Some Python dependencies are missing"
        print_status $YELLOW "💡 Install with: pip install -r requirements.txt"
        return 1
    else
        print_status $GREEN "✅ Python dependencies are available"
        return 0
    fi
}

# Function to show demo information
show_demo_info() {
    local demo_num=$1
    local idx=$((demo_num - 1))
    
    echo
    print_status $BLUE "🚀 Demo ${demo_num}: ${DEMO_NAMES[$idx]}"
    print_status $YELLOW "⏱️  Estimated time: ${DEMO_TIMES[$idx]}"
    print_status $GREEN "📝 Description: ${DEMO_DESCS[$idx]}"
    echo
}

# Function to run a specific demo
run_demo() {
    local demo_num=$1
    local interactive=$2
    local real_data=$3
    
    local idx=$((demo_num - 1))
    local demo_dir="${DEMO_DIRS[$idx]}"
    local demo_path="examples/${demo_dir}"
    
    # Check if demo directory exists
    if [ ! -d "$demo_path" ]; then
        print_status $RED "❌ Demo directory not found: $demo_path"
        return 1
    fi
    
    # Check if main.py exists
    if [ ! -f "$demo_path/main.py" ]; then
        print_status $RED "❌ Demo script not found: $demo_path/main.py"
        return 1
    fi
    
    # Show demo information
    show_demo_info $demo_num
    
    # Prepare command
    local cmd="cd $demo_path && python3 main.py"
    
    if [ "$interactive" = "false" ]; then
        cmd="$cmd --no-interactive"
    fi
    
    if [ "$real_data" = "true" ]; then
        cmd="$cmd --real-data"
    fi
    
    # Add repository path if specified
    if [ -n "$4" ]; then
        cmd="$cmd --repository $4"
    fi
    
    print_status $BLUE "🎬 Running demo with command:"
    print_status $YELLOW "   $cmd"
    echo
    
    # Run the demo
    if eval $cmd; then
        print_status $GREEN "✅ Demo ${demo_num} completed successfully!"
        return 0
    else
        print_status $RED "❌ Demo ${demo_num} failed"
        return 1
    fi
}

# Function to show help
show_help() {
    echo "MCP Gateway Demo Runner"
    echo
    echo "Usage: $0 <demo_number> [options]"
    echo
    echo "Demo Numbers:"
    for i in {1..4}; do
        local idx=$((i - 1))
        echo "  $i - ${DEMO_NAMES[$idx]} (${DEMO_TIMES[$idx]})"
        echo "      ${DEMO_DESCS[$idx]}"
    done
    echo
    echo "Options:"
    echo "  --interactive     Run in interactive mode (default)"
    echo "  --no-interactive  Run in automated mode"
    echo "  --real-data       Use real repository data (requires setup)"
    echo "  --repository <path>  Specify repository path to analyze"
    echo "  --help            Show this help message"
    echo
    echo "Examples:"
    echo "  $0 1                           # Run Demo 1 interactively"
    echo "  $0 2 --no-interactive         # Run Demo 2 in automated mode"
    echo "  $0 3 --real-data             # Run Demo 3 with real data"
    echo "  $0 4 --repository /path/to/repo  # Run Demo 4 on specific repo"
    echo
    echo "Prerequisites:"
    echo "  • MCP Gateway running on port 4444"
    echo "  • Python dependencies installed (pip install -r requirements.txt)"
    echo "  • Git repositories available for analysis"
}

# Function to list available demos
list_demos() {
    echo "Available Demos:"
    echo
    for i in {1..4}; do
        local idx=$((i - 1))
        echo "  Demo $i: ${DEMO_NAMES[$idx]}"
        echo "    Time: ${DEMO_TIMES[$idx]}"
        echo "    Description: ${DEMO_DESCS[$idx]}"
        echo
    done
}

# Main script logic
main() {
    # Check if help is requested
    if [[ "$1" == "--help" || "$1" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    # Check if list is requested
    if [[ "$1" == "--list" || "$1" == "-l" ]]; then
        list_demos
        exit 0
    fi
    
    # Check if demo number is provided
    if [ -z "$1" ]; then
        print_status $RED "❌ Demo number is required"
        echo
        show_help
        exit 1
    fi
    
    local demo_num=$1
    shift
    
    # Validate demo number
    if ! [[ "$demo_num" =~ ^[1-4]$ ]]; then
        print_status $RED "❌ Invalid demo number: $demo_num"
        print_status $YELLOW "💡 Valid demo numbers: 1, 2, 3, 4"
        exit 1
    fi
    
    # Parse options
    local interactive=true
    local real_data=false
    local repository_path=""
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --interactive)
                interactive=true
                shift
                ;;
            --no-interactive)
                interactive=false
                shift
                ;;
            --real-data)
                real_data=true
                shift
                ;;
            --repository)
                repository_path="$2"
                shift 2
                ;;
            *)
                print_status $RED "❌ Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    shift $((OPTIND -1))
    
    # Print header
    echo
    print_status $BLUE "🚀 MCP Gateway Demo Runner"
    print_status $BLUE "=========================="
    echo
    
    # Check prerequisites
    if ! check_mcp_gateway; then
        print_status $RED "❌ Cannot proceed without MCP Gateway"
        exit 1
    fi
    
    if ! check_python_deps; then
        print_status $YELLOW "⚠️  Some dependencies missing, but continuing..."
        echo
    fi
    
    # Run the demo
    if run_demo $demo_num $interactive $real_data "$repository_path"; then
        echo
        print_status $GREEN "🎉 Demo completed successfully!"
        
        # Show next steps
        if [ $demo_num -lt 4 ]; then
            local next_demo=$((demo_num + 1))
            local next_idx=$((next_demo - 1))
            echo
            print_status $BLUE "🔗 Next: Try Demo $next_demo - ${DEMO_NAMES[$next_idx]}"
            print_status $YELLOW "   Run: $0 $next_demo"
        fi
        
        exit 0
    else
        echo
        print_status $RED "💥 Demo failed. Check the output above for errors."
        exit 1
    fi
}

# Run main function with all arguments
main "$@"
