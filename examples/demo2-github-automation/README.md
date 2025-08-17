# Demo 2: Full GitHub Workflow Automation

[![Demo Level](https://img.shields.io/badge/Level-Intermediate-blue.svg)](README.md)
[![Time](https://img.shields.io/badge/Time-10%20minutes-green.svg)](README.md)
[![MCP Tools](https://img.shields.io/badge/MCP%20Tools-5+-orange.svg)](README.md)

> **Complete PR lifecycle automation from local changes to deployment**

---

## 🎯 What This Demo Accomplishes

**Demo 2: Full GitHub Workflow Automation** demonstrates end-to-end automation of the complete GitHub development workflow, from analyzing local changes to creating pull requests, all orchestrated through MCP Gateway.

### 🚀 Key Capabilities

- **Complete PR Lifecycle**: Automate every step from analysis to deployment
- **Intelligent Branch Management**: Create feature branches with smart naming
- **Automated PR Creation**: Generate pull requests with comprehensive descriptions
- **Pattern Learning**: Store and recall workflow patterns for continuous improvement
- **Cross-Tool Orchestration**: Coordinate multiple MCP tools seamlessly

### 📊 Measurable Impact

| Metric | Before MCP | After MCP | Improvement |
|--------|------------|-----------|-------------|
| **PR Creation Time** | 4-6 hours | 10 minutes | **95%** |
| **Branch Management** | Manual creation | Automated | **100%** |
| **PR Description** | Basic templates | Rich, contextual | **100%** |
| **Workflow Consistency** | Developer-dependent | Standardized | **100%** |

---

## 🏗️ Architecture

### MCP Tools Used

```
┌─────────────────────────────────────────────────────────────────┐
│                Full GitHub Workflow Automation                 │
├─────────────────────────────────────────────────────────────────┤
│  Repository Analysis  │  PR Generation  │  GitHub Operations │
│  & Change Detection   │  & Planning     │  & Automation      │
├─────────────────────────────────────────────────────────────────┤
│  local-repo-analyzer-get-outstanding-summary                   │
│  • Analyzes repository state                                  │
│  • Detects uncommitted changes                                │
│  • Provides change overview                                   │
├─────────────────────────────────────────────────────────────────┤
│  local-repo-analyzer-analyze-working-directory                 │
│  • Detailed working directory analysis                        │
│  • Change categorization and complexity assessment             │
│  • File-by-file change tracking                               │
├─────────────────────────────────────────────────────────────────┤
│  pr-recommender-generate-pr-recommendations                   │
│  • Generates PR recommendations                               │
│  • Estimates effort and time                                  │
│  • Suggests optimal PR structure                              │
├─────────────────────────────────────────────────────────────────┤
│  github-server-create-branch                                  │
│  • Creates feature branches                                   │
│  • Implements smart naming conventions                        │
│  • Sets up branch protection                                  │
├─────────────────────────────────────────────────────────────────┤
│  github-server-create-pull-request                            │
│  • Creates pull requests                                      │
│  • Generates rich descriptions                                │
│  • Assigns reviewers automatically                            │
├─────────────────────────────────────────────────────────────────┤
│  memory-server-store                                          │
│  • Stores workflow patterns                                   │
│  • Enables continuous learning                                │
│  • Improves future automation                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Workflow Sequence

1. **Repository State Analysis**: Get current repository status
2. **Working Directory Analysis**: Analyze uncommitted changes
3. **PR Recommendation Generation**: Create optimal PR structure
4. **Branch Creation**: Automatically create feature branches
5. **PR Creation**: Generate pull requests with rich descriptions
6. **Pattern Storage**: Learn from the workflow for future improvements

---

## 🚀 Quick Start

### Prerequisites

- **MCP Gateway**: Running on `localhost:4444`
- **GitHub MCP Server**: Registered and accessible
- **Memory Plugin**: For pattern storage and learning
- **Python 3.8+**: For demo execution
- **Git Repository**: With uncommitted changes

### Run the Demo

```bash
# From the repository root
./scripts/run-demo.sh 2

# Or run directly
cd examples/demo2-github-automation
python3 main.py

# With real data testing
python3 main.py --real-data
```
# From the repository root
./scripts/run-demo.sh 2

# Or run directly
cd examples/demo2-github-automation
python3 main.py

# Non-interactive mode
python3 main.py --no-interactive
```

### Expected Output

```
🚀 Starting Demo 2: Full GitHub Workflow Automation with Real MCP Tools
⏱️  Estimated time: 10 minutes
🎯 Goal: Complete PR lifecycle from local changes to deployment using MCP

Step 1/6: 🔍 MCP Gateway Connectivity Check
✅ MCP Gateway is accessible

Step 2/6: 🔍 MCP Tool Discovery
✅ Found 100 MCP tools
✅ GitHub tools available: 51
✅ Repository analysis tools available: 18
✅ PR tools available: 5

Step 3/6: 🔍 Repository State Analysis
✅ Repository state analysis completed

Step 4/6: 🔍 Working Directory Analysis
✅ Working directory analysis completed

Step 5/6: 🎯 PR Recommendation Generation
✅ PR recommendations generated

Step 6/6: 🚀 GitHub Automation
✅ GitHub automation completed

🎉 Demo 2 Completed Successfully!
✅ ⏰ Time Saved: 4 hours → 10 minutes (3 hours 50 minutes saved)
✅ 🌿 Branches Created: X
✅ 📋 PRs Created: X
✅ 🔍 Changes Analyzed: X
```

---

## 🔧 Configuration

### Environment Variables

```bash
# MCP Gateway Configuration
export MCP_GATEWAY_URL="http://localhost:4444"
export MCP_GATEWAY_TOKEN="your-jwt-token"

# GitHub Configuration
export GITHUB_TOKEN="your-github-token"
export GITHUB_REPOSITORY="owner/repo"

# Memory Plugin Configuration
export MEMORY_SERVER_URL="http://localhost:9002"
```

### Demo Parameters

```bash
# Command line options
python3 main.py --help

# Available options:
--interactive     # Interactive mode (default)
--no-interactive  # Non-interactive mode
--real-data       # Use real MCP tools (default)
--simulated       # Use simulated data
--repository      # Custom repository path
--dry-run         # Show what would happen without executing
```

---

## 📊 Understanding the Results

### Repository State Analysis

```json
{
  "repository_name": "mcp-gateway-demo",
  "current_branch": "main",
  "uncommitted_changes": 5,
  "staged_changes": 0,
  "untracked_files": 3,
  "last_commit": "feat: add demo automation",
  "remote_status": "ahead by 2 commits"
}
```

### PR Recommendations

```json
{
  "recommendations": [
    {
      "title": "Add API endpoint validation",
      "description": "Implement comprehensive validation for new API endpoints",
      "files": ["src/api/validation.py", "tests/test_validation.py"],
      "estimated_effort": "2-3 hours",
      "priority": "high",
      "rationale": "Critical security improvement for API endpoints"
    }
  ],
  "total_effort": "4-6 hours",
  "recommended_approach": "Split into focused PRs by feature area"
}
```

### GitHub Operations

```json
{
  "branches_created": [
    {
      "name": "feature/api-validation",
      "base": "main",
      "protection_enabled": true
    }
  ],
  "pull_requests_created": [
    {
      "number": 123,
      "title": "Add API endpoint validation",
      "url": "https://github.com/owner/repo/pull/123",
      "reviewers_assigned": ["tech-lead", "security-team"]
    }
  ]
}
```

---

## 🎭 Simulation Mode

When MCP tools are unavailable, the demo falls back to simulation mode:

### Simulated GitHub Operations

```python
# Example simulated operations
simulated_branches = [
    GitHubBranch(
        name="feature/api-validation",
        base="main",
        protection_enabled=True
    )
]

simulated_prs = [
    GitHubPR(
        number=123,
        title="Add API endpoint validation",
        url="https://github.com/owner/repo/pull/123",
        reviewers=["tech-lead", "security-team"]
    )
]
```

### Benefits of Simulation

- **No External Dependencies**: Works offline for demonstrations
- **Predictable Results**: Consistent output for presentations
- **Safe Testing**: Validate logic without affecting real repositories
- **Training**: Learn the workflow before production use

---

## 🔍 Troubleshooting

### Common Issues

#### GitHub MCP Server Unavailable

```bash
❌ GitHub tools not available

# Solutions:
1. Check if GitHub MCP server is running
2. Verify server registration with MCP Gateway
3. Check GitHub API token validity
4. Ensure proper authentication
```

#### Memory Plugin Connection Failed

```bash
⚠️  Failed to store patterns in memory plugin

# Solutions:
1. Check memory server connectivity
2. Verify memory server registration
3. Check authentication and permissions
4. Review memory server logs
```

#### Branch Creation Failed

```bash
❌ Failed to create branch

# Solutions:
1. Verify GitHub permissions (branch creation rights)
2. Check branch naming conventions
3. Ensure base branch exists
4. Review GitHub API rate limits
```

### Debug Mode

Enable debug output for detailed troubleshooting:

```bash
# Set debug environment variable
export DEBUG=1

# Run demo with verbose output
python3 main.py --verbose

# Enable GitHub API debugging
export GITHUB_DEBUG=1
```

---

## 🎯 Real Data Testing

### Why Use Real Data?

Demo 2 can run with **real data** instead of simulations, showing actual:
- ✅ **Real repository analysis** with actual Git changes
- ✅ **Real PR recommendations** based on actual file modifications
- ✅ **Real GitHub operations** (branch creation, PR creation)
- ✅ **Real pattern storage** in memory plugin

### Setup for Real Data Testing

#### 1. Prerequisites
- **MCP Gateway Running**: Ensure `docker-compose up -d` is running
- **GitHub Credentials**: Set `GITHUB_TOKEN` and `GITHUB_USERNAME` environment variables
- **Test Repository**: Run `./scripts/setup-test-repo.sh` to create a test repository

#### 2. Run with Real Data
```bash
# Run Demo 2 with real data
./scripts/run-demo.sh 2 --real-data

# Or run directly
cd examples/demo2-github-automation
python3 main.py --real-data
```

#### 3. What Happens in Real Data Mode

**Repository Analysis:**
- Uses `local-repo-analyzer` to analyze actual repository state
- Detects real uncommitted changes and working directory status
- Provides actual change counts and file modifications

**PR Generation:**
- Uses `pr-recommender` to generate recommendations based on real changes
- Analyzes actual file patterns and complexity
- Creates meaningful PR suggestions with real effort estimates

**GitHub Operations:**
- Creates actual Git branches using GitHub MCP server
- Generates real pull requests with comprehensive descriptions
- Stores actual workflow patterns in memory plugin

### Expected Results with Real Data

**With Real Changes:**
- **Repository Status**: Actual working directory state
- **Change Detection**: Real file modifications and line counts
- **PR Recommendations**: Meaningful suggestions based on actual changes
- **GitHub Operations**: Real branches and PRs created
- **Pattern Learning**: Actual workflow patterns stored for future use

---

## 🧪 Testing

### Unit Tests

```bash
# Run tests for this demo
cd examples/demo2-github-automation
python3 -m pytest tests/ -v

# Run with coverage
python3 -m pytest tests/ --cov=. --cov-report=html
```

### Integration Tests

```bash
# Test with real MCP Gateway
./scripts/run-demo.sh 2 --no-interactive

# Test with simulated data
python3 main.py --no-interactive --simulated

# Test with dry-run mode
python3 main.py --no-interactive --dry-run
```

### GitHub Integration Tests

```bash
# Test GitHub operations (use test repository)
export GITHUB_REPOSITORY="your-org/test-repo"
python3 main.py --no-interactive --dry-run

# Test with real repository (be careful!)
python3 main.py --no-interactive
```

---

## 🔗 Integration

### With Other Demos

This demo builds upon and integrates with other demos:

- **Demo 1**: Uses repository analysis results
- **Demo 3**: Provides data for enterprise intelligence
- **Demo 4**: Triggers AI team member workflows

### With Your CI/CD Pipeline

Integrate this demo into your existing CI/CD process:

```yaml
# GitHub Actions example
- name: Analyze and Create PRs
  run: |
    python3 examples/demo2-github-automation/main.py --no-interactive
    # Use results to trigger deployments
```

### With GitHub Apps

Extend functionality with GitHub Apps:

```python
# GitHub App integration
from github import Github

github = Github(app_auth_token)
repo = github.get_repo("owner/repo")

# Create PR with custom checks
pr = repo.create_pull(
    title="Automated PR",
    body="Generated by MCP Gateway",
    head="feature-branch",
    base="main"
)
```

---

## 📚 Next Steps

### Immediate Actions

1. **Run the Demo**: Execute `./scripts/run-demo.sh 2`
2. **Review Results**: Understand the automation output
3. **Customize**: Modify for your repository structure
4. **Integrate**: Add to your CI/CD pipeline

### Advanced Usage

1. **Demo 3**: Enterprise development intelligence
2. **Demo 4**: AI development team member
3. **Custom Workflows**: Build specialized automation
4. **Multi-Repository**: Scale across multiple projects

### Learning Resources

- [GitHub MCP Server](https://github.com/modelcontextprotocol/servers)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [MCP Protocol Specification](https://modelcontextprotocol.io/)
- [GitHub Apps Guide](https://docs.github.com/en/apps)

---

## 🤝 Contributing

### Report Issues

Found a bug or have a feature request? [Open an issue](../../issues) with:

- **Demo**: Demo 2: Full GitHub Workflow Automation
- **Environment**: OS, Python version, MCP Gateway version
- **GitHub Setup**: Repository details, permissions
- **Steps to Reproduce**: Clear reproduction steps

### Submit Improvements

Want to enhance this demo? [Submit a PR](../../pulls) with:

- **Clear Description**: What the change accomplishes
- **Tests**: Include tests for new functionality
- **Documentation**: Update README if needed
- **GitHub Integration**: Ensure compatibility with GitHub APIs

---

## 📄 License

This demo is part of the MCP Gateway Demo Repository, licensed under the Apache License 2.0.

---

*Last updated: August 2024*
*Demo Level: Intermediate*
*Estimated Time: 10 minutes*
