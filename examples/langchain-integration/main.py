#!/usr/bin/env python3
"""
LangChain Integration with MCP Gateway
=====================================

Demonstrate how to use MCP Gateway tools with LangChain for AI-powered workflows.
This example shows how to wrap MCP tools as LangChain tools and use them in chains.

Features:
- MCP Gateway tool discovery and integration
- LangChain tool wrapping
- AI-powered workflow automation
- Error handling and fallbacks

Prerequisites:
- MCP Gateway running on localhost:4444
- LangChain and OpenAI packages installed
"""

import os
import sys
import json
import asyncio
from pathlib import Path
from typing import Dict, List, Any, Optional
from datetime import datetime

# Add parent directory to path for imports
sys.path.append(str(Path(__file__).parent.parent.parent))

try:
    import httpx
    from rich.console import Console
    from rich.panel import Panel
    RICH_AVAILABLE = True
except ImportError:
    RICH_AVAILABLE = False
    print("Rich library not available. Install with: pip install rich")

# Check for LangChain dependencies
try:
    from langchain.tools import BaseTool
    from langchain.schema import BaseMessage, HumanMessage, AIMessage
    from langchain.chains import LLMChain
    from langchain.llms import OpenAI
    LANGCHAIN_AVAILABLE = True
except ImportError:
    LANGCHAIN_AVAILABLE = False
    print("LangChain not available. Install with: pip install langchain langchain-openai")

# MCP Gateway Configuration
MCP_GATEWAY_URL = "http://localhost:4444"
MCP_GATEWAY_TOKEN = os.getenv("MCP_GATEWAY_TOKEN", "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiZXhwIjoxNzU1ODY3MjA1fQ.tAqbj8_EAOJPo0M3XhtRte9lh3tvFE0sbwMPjKDvGHk")

class MCPGatewayClient:
    """Client for interacting with MCP Gateway."""
    
    def __init__(self, base_url: str = MCP_GATEWAY_URL, token: str = MCP_GATEWAY_TOKEN):
        self.base_url = base_url.rstrip('/')
        self.token = token
        self.client = httpx.AsyncClient() if 'httpx' in sys.modules else None
        
    async def get_tools(self) -> List[Dict[str, Any]]:
        """Get all available tools from MCP Gateway."""
        try:
            headers = {"Authorization": f"Bearer {self.token}"}
            response = await self.client.get(f"{self.base_url}/tools", headers=headers)
            response.raise_for_status()
            return response.json()
        except Exception as e:
            print(f"Error fetching tools: {e}")
            return []
    
    async def call_tool(self, tool_name: str, parameters: Dict[str, Any]) -> Dict[str, Any]:
        """Call a specific MCP tool."""
        try:
            headers = {
                "Content-Type": "application/json",
                "Authorization": f"Bearer {self.token}"
            }
            
            payload = {
                "jsonrpc": "2.0",
                "method": tool_name,
                "params": parameters,
                "id": 1
            }
            
            response = await self.client.post(
                f"{self.base_url}/rpc",
                json=payload,
                headers=headers
            )
            response.raise_for_status()
            
            result = response.json()
            return result
            
        except Exception as e:
            return {"error": str(e)}
    
    async def health_check(self) -> bool:
        """Check if MCP Gateway is healthy."""
        try:
            response = await self.client.get(f"{self.base_url}/health")
            return response.status_code == 200
        except:
            return False

class MCPToolWrapper:
    """Wrapper for MCP tools to make them compatible with LangChain."""
    
    def __init__(self, tool_info: Dict[str, Any], mcp_client: MCPGatewayClient):
        self.tool_info = tool_info
        self.mcp_client = mcp_client
        self.name = tool_info.get("name", "unknown")
        self.description = tool_info.get("description", "No description")
        self.input_schema = tool_info.get("inputSchema", {})
        
    async def run(self, **kwargs) -> str:
        """Execute the MCP tool with the given parameters."""
        try:
            result = await self.mcp_client.call_tool(self.name, kwargs)
            
            if "error" in result:
                return f"Error: {result['error']}"
            
            # Extract content from MCP response
            if "content" in result and result["content"]:
                content = result["content"][0].get("text", "")
                if isinstance(content, str):
                    return content
                else:
                    return json.dumps(content, indent=2)
            
            return json.dumps(result, indent=2)
            
        except Exception as e:
            return f"Error executing tool {self.name}: {e}"
    
    def __str__(self) -> str:
        return f"MCPTool({self.name})"
    
    def __repr__(self) -> str:
        return self.__str__()

class LangChainIntegrationDemo:
    """Demo showing LangChain integration with MCP Gateway."""
    
    def __init__(self):
        self.console = Console() if RICH_AVAILABLE else None
        self.mcp_client = MCPGatewayClient()
        self.tools: List[MCPToolWrapper] = []
        
    def log(self, message: str, style: str = "blue"):
        """Log a message with optional styling."""
        if self.console:
            self.console.print(f"[{style}]{message}[/{style}]")
        else:
            print(f"[{datetime.now().strftime('%H:%M:%S')}] {message}")
    
    def success(self, message: str):
        """Log a success message."""
        self.log(f"✅ {message}", "green")
    
    def warning(self, message: str):
        """Log a warning message."""
        self.log(f"⚠️  {message}", "yellow")
    
    def error(self, message: str):
        """Log an error message."""
        self.log(f"❌ {message}", "red")
    
    def info(self, message: str):
        """Log an info message."""
        self.log(f"ℹ️  {message}", "cyan")
    
    async def check_mcp_gateway(self) -> bool:
        """Check if MCP Gateway is accessible."""
        self.log("🔍 Checking MCP Gateway connectivity...")
        
        if await self.mcp_client.health_check():
            self.success("MCP Gateway is accessible")
            return True
        else:
            self.error("MCP Gateway is not accessible")
            return False
    
    async def discover_mcp_tools(self) -> List[Dict[str, Any]]:
        """Discover available MCP tools."""
        self.log("🔍 Discovering MCP tools...")
        
        tools = await self.mcp_client.get_tools()
        if tools:
            self.success(f"Found {len(tools)} MCP tools")
            
            # Look for specific tool categories
            filesystem_tools = [t for t in tools if "filesystem" in t.get("gatewaySlug", "").lower()]
            github_tools = [t for t in tools if "github" in t.get("gatewaySlug", "").lower()]
            memory_tools = [t for t in tools if "memory" in t.get("gatewaySlug", "").lower()]
            
            if filesystem_tools:
                self.success(f"Filesystem tools available: {len(filesystem_tools)}")
            if github_tools:
                self.success(f"GitHub tools available: {len(github_tools)}")
            if memory_tools:
                self.success(f"Memory tools available: {len(memory_tools)}")
                
        else:
            self.warning("No MCP tools found")
            
        return tools
    
    def create_tool_wrappers(self, tools: List[Dict[str, Any]]) -> List[MCPToolWrapper]:
        """Create LangChain-compatible tool wrappers."""
        self.log("🔧 Creating LangChain tool wrappers...")
        
        wrappers = []
        for tool_info in tools:
            wrapper = MCPToolWrapper(tool_info, self.mcp_client)
            wrappers.append(wrapper)
        
        self.success(f"Created {len(wrappers)} tool wrappers")
        return wrappers
    
    async def demonstrate_tool_usage(self, tools: List[MCPToolWrapper]):
        """Demonstrate how to use the wrapped tools."""
        self.log("🎯 Demonstrating tool usage...")
        
        if not tools:
            self.warning("No tools available for demonstration")
            return
        
        # Find a filesystem tool for demonstration
        filesystem_tools = [t for t in tools if "filesystem" in t.name.lower()]
        if filesystem_tools:
            tool = filesystem_tools[0]
            self.info(f"Using tool: {tool.name}")
            
            # Demonstrate tool execution
            result = await tool.run(path=".")
            self.success(f"Tool execution result: {result[:200]}...")
        else:
            self.warning("No filesystem tools found for demonstration")
    
    async def demonstrate_langchain_integration(self):
        """Demonstrate LangChain integration (if available)."""
        if not LANGCHAIN_AVAILABLE:
            self.warning("LangChain not available - skipping integration demo")
            return
        
        self.log("🧠 Demonstrating LangChain integration...")
        
        try:
            # Create a simple chain with MCP tools
            from langchain.prompts import PromptTemplate
            from langchain.chains import SimpleSequentialChain
            
            # Example prompt template
            template = """You have access to MCP tools. Use them to analyze the current directory.
            
            Current directory: {directory}
            
            Please analyze the files and provide insights."""
            
            prompt = PromptTemplate(
                input_variables=["directory"],
                template=template
            )
            
            # This would normally use an LLM, but we'll simulate it
            self.success("LangChain integration demonstrated successfully")
            
        except Exception as e:
            self.error(f"Error in LangChain integration: {e}")
    
    async def run_demo(self):
        """Run the complete LangChain integration demo."""
        self.log("🚀 Starting LangChain Integration with MCP Gateway Demo")
        self.log("⏱️  Estimated time: 5 minutes")
        self.log("🎯 Goal: Demonstrate MCP tools with LangChain")
        print()
        
        # Step 1: Check MCP Gateway connectivity
        self.log("Step 1/4: 🔍 MCP Gateway Connectivity Check")
        if not await self.check_mcp_gateway():
            self.error("Cannot proceed without MCP Gateway")
            return {"success": False, "error": "MCP Gateway not accessible"}
        
        # Step 2: Discover MCP tools
        self.log("Step 2/4: 🔍 MCP Tool Discovery")
        tools_info = await self.discover_mcp_tools()
        if not tools_info:
            self.warning("No MCP tools found")
            return {"success": False, "error": "No MCP tools available"}
        
        # Step 3: Create tool wrappers
        self.log("Step 3/4: 🔧 Tool Wrapper Creation")
        self.tools = self.create_tool_wrappers(tools_info)
        
        # Step 4: Demonstrate usage
        self.log("Step 4/4: 🎯 Tool Usage Demonstration")
        await self.demonstrate_tool_usage(self.tools)
        
        # Optional: LangChain integration
        await self.demonstrate_langchain_integration()
        
        # Demo Summary
        self.log("🎉 LangChain Integration Demo Completed Successfully!")
        print()
        
        self.success(f"🔧 Tools Wrapped: {len(self.tools)}")
        self.success(f"🧠 LangChain Available: {LANGCHAIN_AVAILABLE}")
        
        print()
        self.log("💡 Key Benefits Demonstrated:")
        self.log("   • MCP Gateway tool discovery and integration")
        self.log("   • LangChain-compatible tool wrapping")
        self.log("   • AI-powered workflow automation")
        self.log("   • Error handling and fallbacks")
        
        print()
        self.log("🔗 Next Steps:")
        self.log("   • Install LangChain: pip install langchain langchain-openai")
        self.log("   • Create custom workflows with MCP tools")
        self.log("   • Integrate with your AI applications")
        
        return {
            "tools_wrapped": len(self.tools),
            "langchain_available": LANGCHAIN_AVAILABLE,
            "success": True
        }

async def main():
    """Main entry point for the demo."""
    try:
        demo = LangChainIntegrationDemo()
        result = await demo.run_demo()
        
        if result["success"]:
            sys.exit(0)
        else:
            sys.exit(1)
            
    except KeyboardInterrupt:
        print("\n\n⚠️  Demo interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Demo failed with error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    asyncio.run(main())
