# Legacy Setup Scripts

This directory contains legacy setup scripts that were used in earlier versions of the MCP Gateway Demo.

## 📄 `complete-mcp-setup.sh`

### What It Was
A bash script that manually set up MCP servers using PM2 process management and hardcoded paths.

### Why It Was Moved to Legacy
- **Hardcoded paths**: Contains machine-specific directory paths
- **PM2 dependency**: Requires PM2 to be installed locally
- **Complex setup**: Manual dependency installation and server management
- **Machine-specific**: Won't work on other machines without modification
- **Mixed transports**: Combines stdio and HTTP modes in confusing ways

### What Replaced It
The **Docker Compose setup** (`docker-compose.yml`) provides:
- ✅ **Portable setup** that works anywhere
- ✅ **Containerized services** with proper isolation
- ✅ **Environment variables** for configuration
- ✅ **Standardized deployment** process
- ✅ **Easy scaling** and service management

## 🚀 Current Recommended Setup

Use the Docker Compose setup instead:

```bash
# Start the full MCP Gateway stack
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f mcp-gateway
```

## 🔧 Migration Notes

If you were using the legacy script:
1. **Install Docker** and Docker Compose
2. **Copy environment variables** to `.env` file
3. **Run `docker-compose up -d`** instead of the script
4. **Use `docker-compose logs`** instead of PM2 logs

## 📚 Documentation

- **Main README**: [../README.md](../README.md)
- **Docker Setup**: [../../docker-compose.yml](../../docker-compose.yml)
- **Quick Start**: [../../README.md#quick-start](../../README.md#quick-start)
