# Demo 1: Smart Development Workflow

[![Demo Level](https://img.shields.io/badge/Level-Beginner-green.svg)](README.md)
[![Time](https://img.shields.io/badge/Time-5%20minutes-blue.svg)](README.md)
[![MCP Tools](https://img.shields.io/badge/MCP%20Tools-3+-orange.svg)](README.md)

> **Transform messy working directories into organized PRs in minutes, not hours**

---

## 🎯 What This Demo Accomplishes

**Demo 1: Smart Development Workflow** demonstrates how MCP Gateway can revolutionize your daily development workflow by automating the tedious process of organizing code changes into meaningful pull requests.

### 🚀 Key Capabilities

- **Real-time Git Analysis**: Automatically detect and categorize all changes in your working directory
- **Intelligent Change Classification**: Group changes by type, complexity, and estimated effort
- **Automated PR Recommendations**: Generate smart PR suggestions based on change patterns
- **GitHub Integration**: Simulate the complete PR creation workflow

### 📊 Measurable Impact

| Metric | Before MCP | After MCP | Improvement |
|--------|------------|-----------|-------------|
| **PR Organization Time** | 2-4 hours | 2-10 minutes | **90-95%** |
| **Change Analysis** | Manual review | Automated categorization | **100%** |
| **PR Planning** | Guesswork | Data-driven insights | **100%** |
| **Workflow Consistency** | Developer-dependent | Standardized | **100%** |

---

## 🏗️ Architecture

### MCP Tools Used

```
┌─────────────────────────────────────────────────────────────────┐
│                    Smart Development Workflow                   │
├─────────────────────────────────────────────────────────────────┤
│  Working Directory  │  Change Analysis  │  PR Generation        │
│  Analysis           │  & Categorization │  & GitHub Integration │
├─────────────────────────────────────────────────────────────────┤
│  local-repo-analyzer-analyze-working-directory                  │
│  • Detects uncommitted changes                                  │
│  • Categorizes file types                                       │
│  • Calculates complexity scores                                 │
├─────────────────────────────────────────────────────────────────┤
│  pr-recommender-generate-pr-recommendations                     │
│  • Analyzes change patterns                                     │
│  • Generates PR recommendations                                 │
│  • Estimates effort and time                                    │
├─────────────────────────────────────────────────────────────────┤
│  github-server-* (simulated)                                    │
│  • Branch creation simulation                                   │
│  • PR creation simulation                                       │
│  • Repository status checks                                     │
└─────────────────────────────────────────────────────────────────┘
```

### Data Flow

1. **Input**: Working directory with uncommitted changes
2. **Analysis**: MCP tools analyze changes and categorize them
3. **Classification**: Changes grouped by type, complexity, and effort
4. **Recommendation**: PR suggestions generated based on patterns
5. **Output**: Organized PR plan with time estimates and priorities

---

## 🚀 Quick Start

### Prerequisites

- **MCP Gateway**: Running on `localhost:4444`
- **Python 3.8+**: For demo execution
- **Git Repository**: With uncommitted changes to analyze

### Run the Demo

```bash
# From the repository root
./scripts/run-demo.sh 1

# Or run directly
cd examples/demo1-smart-workflow
python3 main.py

# Non-interactive mode
python3 main.py --no-interactive
```

### Expected Output

```
🚀 Starting Demo 1: Smart Development Workflow with Real MCP Tools
⏱️  Estimated time: 5 minutes
🎯 Goal: Transform messy working directory into organized PRs using MCP

Step 1/5: 🔍 MCP Gateway Connectivity Check
```

---

## 🔍 Demo Walkthrough

### Step 1: Git Analysis (1 minute)

The demo begins by analyzing your working directory:

```
🔍 Analyzing working directory...
✅ Found changes in working directory
```

**What's happening behind the scenes:**
- MCP Gateway connects to local repository analyzer tools
- AI-powered analysis examines file changes, additions, and deletions
- Complexity scoring algorithms assess the impact of each change
- Change categorization based on file patterns and content analysis

**Example changes detected:**
- `src/api/endpoints.py` - New API endpoints (45 lines added, 12 deleted)
- `src/models/user.py` - User model refactoring (23 lines added, 8 deleted)
- `tests/test_api.py` - New test coverage (67 lines added)
- `docs/api.md` - API documentation updates (34 lines added, 15 deleted)
- `src/utils/helpers.py` - New utility functions (89 lines added)
- `config/database.yml` - Configuration updates (12 lines added, 5 deleted)

### Step 2: Change Analysis (1 minute)

The system analyzes patterns and provides insights:

```
📊 Analyzing change patterns...
✅ Change analysis completed
```

**Analysis results:**
- **Total Files**: 6
- **Lines Added**: 264
- **Lines Deleted**: 40
- **Estimated Time**: 8-12 hours
- **Recommended Approach**: Split into focused PRs by category

**Complexity distribution:**
- **High Complexity**: 2 files (API endpoints, utility functions)
- **Medium Complexity**: 2 files (user model, tests)
- **Low Complexity**: 2 files (documentation, configuration)

### Step 3: PR Recommendations (1 minute)

AI-powered recommendations are generated:

```
🎯 Generating PR recommendations...
✅ Generated 3 PR recommendations
```

**PR 1: API Endpoints & Models**
- **Files**: `endpoints.py`, `user.py`
- **Type**: Feature development
- **Effort**: 4-6 hours
- **Priority**: High

**PR 2: Test Coverage**
- **Files**: `test_api.py`
- **Type**: Testing
- **Effort**: 2-3 hours
- **Priority**: Medium

**PR 3: Documentation & Configuration**
- **Files**: `api.md`, `database.yml`, `helpers.py`
- **Type**: Documentation & utilities
- **Effort**: 2-3 hours
- **Priority**: Low

### Step 4: GitHub Integration (1 minute)

The demo simulates GitHub operations:

```
🔗 Performing GitHub Operations...
🌿 Creating feature branches...
📋 Creating pull requests...
✅ GitHub integration completed
```

**What's simulated:**
- Feature branch creation for each PR
- Commit messages with descriptive titles
- Pull request descriptions with change summaries
- Review assignments and labels

### Step 5: Results Summary (1 minute)

Final summary of what was accomplished:

```
🎉 Demo 1 Completed Successfully!

✅ ⏰ Time Saved: 2 hours → 2 minutes (1 hour 58 minutes saved)
✅ 📋 PRs Generated: 3
✅ 🎯 Files Organized: 6
✅ 🔗 GitHub Operations: Simulated
```

---

## 🎯 Real Data Testing

### Why Use Real Data?

Demo 1 can run with **real data** instead of simulations, showing actual:
- ✅ **Real Git changes** with actual line counts
- ✅ **Real MCP tool responses** from published containers
- ✅ **Real repository analysis** of your actual codebase
- ✅ **Real GitHub operations** (branches, commits, PRs)

### Setup for Real Data Testing

#### 1. Prerequisites
- **MCP Gateway Running**: Ensure `docker-compose up -d` is running
- **GitHub Credentials**: Set `GITHUB_TOKEN` and `GITHUB_USERNAME` environment variables
- **Test Repository**: Run `./scripts/setup-test-repo.sh` to create a test repository

#### 2. Run with Real Data
```bash
# Run Demo 1 with real data
./scripts/run-demo.sh 1 --real-data

# Or run directly
cd examples/demo1-smart-workflow
python3 main.py --real-data
```

#### 3. What Happens in Real Data Mode

**Test Repository Setup:**
- Automatically detects existing `test-repo` directory
- Sets working directory to test repository for analysis
- Verifies GitHub credentials are available

**Real Git Analysis:**
- Uses `local-repo-analyzer` MCP tool to analyze actual repository
- Detects real file changes (modified, added, untracked, deleted)
- Analyzes actual line additions/deletions
- Categorizes files by type and complexity

**Real PR Recommendations:**
- Uses `pr-recommender` MCP tool to generate recommendations
- Analyzes actual file changes and patterns
- Generates intelligent PR suggestions based on real data
- Provides actionable recommendations for organizing changes

**Real GitHub Operations:**
- Creates actual Git branches for each PR recommendation
- Makes real commits with sample implementation files
- Attempts to create GitHub PRs using GitHub MCP server
- Falls back to local operations if GitHub API fails

### Expected Results with Real Data

**With Real Changes:**
- **Files Detected**: 3+ files with actual content changes
- **Line Changes**: Should show actual additions/deletions
- **PR Recommendations**: Should generate meaningful PR suggestions
- **GitHub Operations**: Should create real branches and commits

---

## 🔧 Troubleshooting

### Common Issues

#### Issue: No Line Changes Detected
**Problem**: MCP tool shows `lines_added: 0, lines_deleted: 0` despite file modifications

**Possible Causes:**
1. **File Permissions**: Container can't write to Git index
2. **Staging State**: Tool expects staged vs unstaged changes
3. **Tool Configuration**: MCP tool needs specific Git state

**Solutions:**
1. Check container permissions: `docker exec <container> ls -la /app/test-repo/.git`
2. Try staging changes: `git add .` (if permissions allow)
3. Verify tool parameters in MCP tool call

#### Issue: GitHub Operations Fail
**Problem**: Demo falls back to simulation instead of real GitHub operations

**Possible Causes:**
1. **Missing Credentials**: `GITHUB_TOKEN` not set
2. **API Limits**: GitHub API rate limiting
3. **Repository Access**: Token doesn't have write access

**Solutions:**
1. Verify environment variables: `echo $GITHUB_TOKEN`
2. Check GitHub token permissions
3. Verify repository ownership

#### Issue: MCP Tools Not Responding
**Problem**: Tools return empty results or errors

**Possible Causes:**
1. **Tool Not Running**: Container stopped or crashed
2. **Network Issues**: Gateway can't reach tool containers
3. **Tool Configuration**: Incorrect parameters or paths

**Solutions:**
1. Check container status: `docker ps | grep mcp`
2. Verify tool health: `curl http://localhost:9070/health`
3. Check MCP Gateway logs: `docker-compose logs -f mcp-gateway`

### Debug Commands

```bash
# Check MCP Gateway status
curl http://localhost:4444/health

# Check local-repo-analyzer status
curl http://localhost:9070/health

# Check PR recommender status
curl http://localhost:9071/health

# View container logs
docker-compose logs -f local-repo-analyzer
docker-compose logs -f pr-recommender

# Check test repository status
cd test-repo && git status
```

---

## 📚 Technical Details

### MCP Tool Integration

**Local Repository Analyzer:**
- **Tool**: `local-repo-analyzer-analyze-working-directory`
- **Purpose**: Analyze Git working directory for changes
- **Output**: File changes, line counts, complexity scores
- **Container**: `ghcr.io/manavgup/mcp_local_repo_analyzer:latest`

**PR Recommender:**
- **Tool**: `pr-recommender-generate-pr-recommendations`
- **Purpose**: Generate intelligent PR recommendations
- **Input**: Change analysis data
- **Output**: PR suggestions with effort estimates
- **Container**: `ghcr.io/manavgup/mcp_pr_recommender:latest`

**GitHub Integration:**
- **Tool**: `github-server-*` tools
- **Purpose**: Create branches, commits, and PRs
- **Scope**: Real GitHub operations when credentials available

### Data Structures

**GitChange Object:**
```python
class GitChange:
    file_path: str
    status: str  # 'modified', 'added', 'untracked', 'deleted'
    lines_added: int
    lines_deleted: int
    complexity: str  # 'low', 'medium', 'high'
    category: str   # 'feature', 'bugfix', 'refactor', 'docs'
```

**PR Recommendation:**
```python
class PRRecommendation:
    title: str
    description: str
    files: List[str]
    effort_estimate: str
    priority: str
    category: str
```

---

## 🎯 Use Cases

### Perfect For

- **Feature Development**: Organizing multiple related changes
- **Bug Fixes**: Grouping fixes by component or priority
- **Refactoring**: Splitting large refactoring into manageable PRs
- **Documentation**: Batching documentation updates
- **Team Collaboration**: Standardizing PR organization across team

### Real-World Scenarios

**Scenario 1: Multi-Feature Development**
- Developer working on user authentication and profile management
- Multiple files changed across different components
- Demo helps organize into logical PRs by feature

**Scenario 2: Bug Fix Sprint**
- Multiple bug fixes across different modules
- Demo helps prioritize and group fixes by impact
- Creates focused PRs for easier review

**Scenario 3: Documentation Update**
- Updating API docs, README files, and inline comments
- Demo helps batch documentation changes together
- Creates single PR for all documentation updates

---

## 🚀 Next Steps

### After Running Demo 1

1. **Explore Other Demos**: Try Demo 2 for full GitHub workflow automation
2. **Customize for Your Workflow**: Modify the demo for your specific needs
3. **Integrate with CI/CD**: Use the PR recommendations in your deployment pipeline
4. **Share with Team**: Demonstrate the power of MCP to your development team

### Related Demos

- **[Demo 2](../demo2-github-automation/)**: Full GitHub workflow automation
- **[Demo 3](../demo3-enterprise-intelligence/)**: Multi-repo analysis with memory learning
- **[Demo 4](../demo4-ai-team-member/)**: Autonomous AI team member capabilities

---

## 📞 Support

### Getting Help

- **Documentation**: [Main README](../../README.md)
- **Issues**: [GitHub Issues](https://github.com/manavgup/mcp-gateway-demo/issues)
- **Community**: [MCP Discord](https://discord.gg/modelcontextprotocol)

### Contributing

Found a bug or have an improvement? Contributions are welcome!
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

*Ready to transform your development workflow? Run `./scripts/run-demo.sh 1` and see the magic happen! 🚀*
