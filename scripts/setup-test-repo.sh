#!/bin/bash

# setup-test-repo.sh
# Creates a test GitHub repository with sample code and changes for real demo testing

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
TEST_REPO_NAME="mcp-demo-test-repo"
TEST_REPO_DIR="./test-repo"
GITHUB_USERNAME="${GITHUB_USERNAME:-}"
GITHUB_TOKEN="${GITHUB_TOKEN:-}"

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    print_status $BLUE "🔍 Checking prerequisites..."
    
    # Check if GitHub credentials are provided
    if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
        print_status $RED "❌ GitHub credentials not found!"
        print_status $YELLOW "Please set the following environment variables:"
        print_status $YELLOW "  export GITHUB_USERNAME='your-github-username'"
        print_status $YELLOW "  export GITHUB_TOKEN='your-github-personal-access-token'"
        print_status $YELLOW ""
        print_status $YELLOW "Or run this script with:"
        print_status $YELLOW "  GITHUB_USERNAME=your-username GITHUB_TOKEN=your-token ./scripts/setup-test-repo.sh"
        exit 1
    fi
    
    # Check if required tools are installed
    if ! command -v git &> /dev/null; then
        print_status $RED "❌ Git is not installed"
        exit 1
    fi
    
    if ! command -v curl &> /dev/null; then
        print_status $RED "❌ curl is not installed"
        exit 1
    fi
    
    print_status $GREEN "✅ Prerequisites check passed"
}

# Function to create GitHub repository
create_github_repo() {
    print_status $BLUE "🚀 Creating GitHub repository: $TEST_REPO_NAME"
    
    # Create repository via GitHub API
    local response=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{
            \"name\": \"$TEST_REPO_NAME\",
            \"description\": \"Test repository for MCP Gateway Demo testing\",
            \"private\": false,
            \"auto_init\": true,
            \"gitignore_template\": \"Python\"
        }" \
        "https://api.github.com/user/repos")
    
    if echo "$response" | grep -q "already exists"; then
        print_status $YELLOW "⚠️  Repository already exists, using existing one"
    elif echo "$response" | grep -q "Bad credentials"; then
        print_status $RED "❌ Invalid GitHub token"
        exit 1
    elif echo "$response" | grep -q "Not Found"; then
        print_status $RED "❌ GitHub user not found"
        exit 1
    else
        print_status $GREEN "✅ GitHub repository created successfully"
    fi
    
    # Get repository URL
    REPO_URL="https://github.com/$GITHUB_USERNAME/$TEST_REPO_NAME.git"
    print_status $BLUE "📁 Repository URL: $REPO_URL"
}

# Function to create sample code
create_sample_code() {
    print_status $BLUE "📝 Creating sample code structure..."
    
    # Create test repository directory
    mkdir -p "$TEST_REPO_DIR"
    cd "$TEST_REPO_DIR"
    
    # Initialize git repository
    git init
    git remote add origin "$REPO_URL"
    
    # Create sample Python application
    cat > main.py << 'EOF'
#!/usr/bin/env python3
"""
Sample Python application for MCP Demo testing.
This file will be modified to create real changes for analysis.
"""

import json
import logging
from typing import Dict, List, Optional

class UserManager:
    """Manages user operations for the demo application."""
    
    def __init__(self):
        self.users = {}
        self.logger = logging.getLogger(__name__)
    
    def add_user(self, username: str, email: str, role: str = "user") -> bool:
        """Add a new user to the system."""
        if username in self.users:
            self.logger.warning(f"User {username} already exists")
            return False
        
        self.users[username] = {
            "email": email,
            "role": role,
            "created_at": "2024-01-01T00:00:00Z",
            "status": "active"
        }
        self.logger.info(f"User {username} added successfully")
        return True
    
    def get_user(self, username: str) -> Optional[Dict]:
        """Get user information."""
        return self.users.get(username)
    
    def list_users(self) -> List[str]:
        """List all usernames."""
        return list(self.users.keys())

class DataProcessor:
    """Processes data for the demo application."""
    
    def __init__(self):
        self.data = []
        self.logger = logging.getLogger(__name__)
    
    def add_data(self, item: Dict) -> None:
        """Add data item to the processor."""
        self.data.append(item)
        self.logger.info(f"Added data item: {item}")
    
    def process_data(self) -> List[Dict]:
        """Process all data items."""
        processed = []
        for item in self.data:
            processed_item = {
                "id": len(processed) + 1,
                "data": item,
                "processed_at": "2024-01-01T00:00:00Z"
            }
            processed.append(processed_item)
        return processed

def main():
    """Main application entry point."""
    print("MCP Demo Test Application")
    print("=========================")
    
    # Initialize components
    user_mgr = UserManager()
    data_proc = DataProcessor()
    
    # Add some sample data
    user_mgr.add_user("admin", "admin@example.com", "admin")
    user_mgr.add_user("user1", "user1@example.com", "user")
    user_mgr.add_user("user2", "user2@example.com", "user")
    
    data_proc.add_data({"type": "test", "value": 42})
    data_proc.add_data({"type": "demo", "value": "hello"})
    
    # Display results
    print(f"Users: {user_mgr.list_users()}")
    print(f"Processed data: {len(data_proc.process_data())} items")

if __name__ == "__main__":
    main()
EOF

    # Create requirements.txt
    cat > requirements.txt << 'EOF'
# Sample requirements for MCP Demo testing
fastapi>=0.104.0
uvicorn>=0.24.0
pydantic>=2.5.0
python-dotenv>=1.0.0
requests>=2.31.0
pytest>=7.4.0
pytest-asyncio>=0.21.0
EOF

    # Create README.md
    cat > README.md << 'EOF'
# MCP Demo Test Repository

This is a test repository created for MCP Gateway Demo testing purposes.

## Purpose

This repository contains sample code that will be modified during demo testing to create real changes for analysis by MCP tools.

## Structure

- `main.py` - Sample Python application with user management and data processing
- `requirements.txt` - Python dependencies
- `README.md` - This file

## Testing

The demos will:
1. Clone this repository
2. Make real changes to the code
3. Analyze the changes using MCP tools
4. Create real pull requests
5. Demonstrate real workflow automation

## Note

This is a test repository - changes made here are for demonstration purposes only.
EOF

    # Create .gitignore
    cat > .gitignore << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
EOF

    print_status $GREEN "✅ Sample code structure created"
}

# Function to create initial commit and push
setup_git_repository() {
    print_status $BLUE "🔧 Setting up Git repository..."
    
    cd "$TEST_REPO_DIR"
    
    # Add all files
    git add .
    
    # Create initial commit
    git commit -m "Initial commit: Sample Python application for MCP Demo testing"
    
    # Create and switch to main branch
    git branch -M main
    
    # Push to GitHub
    git push -u origin main
    
    print_status $GREEN "✅ Git repository set up and pushed to GitHub"
}

# Function to create test branches and changes
create_test_changes() {
    print_status $BLUE "🌿 Creating test branches and changes..."
    
    cd "$TEST_REPO_DIR"
    
    # Create feature branch
    git checkout -b feature/user-authentication
    
    # Modify main.py to add authentication
    cat > main.py << 'EOF'
#!/usr/bin/env python3
"""
Sample Python application for MCP Demo testing.
This file will be modified to create real changes for analysis.
"""

import json
import logging
import hashlib
from typing import Dict, List, Optional

class UserManager:
    """Manages user operations for the demo application."""
    
    def __init__(self):
        self.users = {}
        self.logger = logging.getLogger(__name__)
    
    def add_user(self, username: str, email: str, password: str, role: str = "user") -> bool:
        """Add a new user to the system."""
        if username in self.users:
            self.logger.warning(f"User {username} already exists")
            return False
        
        # Hash password for security
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        
        self.users[username] = {
            "email": email,
            "password_hash": hashed_password,
            "role": role,
            "created_at": "2024-01-01T00:00:00Z",
            "status": "active"
        }
        self.logger.info(f"User {username} added successfully")
        return True
    
    def authenticate_user(self, username: str, password: str) -> bool:
        """Authenticate a user with username and password."""
        user = self.users.get(username)
        if not user:
            return False
        
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        return user["password_hash"] == hashed_password
    
    def get_user(self, username: str) -> Optional[Dict]:
        """Get user information."""
        return self.users.get(username)
    
    def list_users(self) -> List[str]:
        """List all usernames."""
        return list(self.users.keys())

class DataProcessor:
    """Processes data for the demo application."""
    
    def __init__(self):
        self.data = []
        self.logger = logging.getLogger(__name__)
    
    def add_data(self, item: Dict) -> None:
        """Add data item to the processor."""
        self.data.append(item)
        self.logger.info(f"Added data item: {item}")
    
    def process_data(self) -> List[Dict]:
        """Process all data items."""
        processed = []
        for item in self.data:
            processed_item = {
                "id": len(processed) + 1,
                "data": item,
                "processed_at": "2024-01-01T00:00:00Z"
            }
            processed.append(processed_item)
        return processed

def main():
    """Main application entry point."""
    print("MCP Demo Test Application")
    print("=========================")
    
    # Initialize components
    user_mgr = UserManager()
    data_proc = DataProcessor()
    
    # Add some sample data
    user_mgr.add_user("admin", "admin@example.com", "admin123", "admin")
    user_mgr.add_user("user1", "user1@example.com", "password1", "user")
    user_mgr.add_user("user2", "user2@example.com", "password2", "user")
    
    data_proc.add_data({"type": "test", "value": 42})
    data_proc.add_data({"type": "demo", "value": "hello"})
    
    # Display results
    print(f"Users: {user_mgr.list_users()}")
    print(f"Processed data: {len(data_proc.process_data())} items")

if __name__ == "__main__":
    main()
EOF

    # Commit the changes
    git add main.py
    git commit -m "feat: Add user authentication with password hashing"
    
    # Create another branch for different changes
    git checkout -b feature/data-validation
    
    # Modify main.py to add data validation
    cat > main.py << 'EOF'
#!/usr/bin/env python3
"""
Sample Python application for MCP Demo testing.
This file will be modified to create real changes for analysis.
"""

import json
import logging
import hashlib
from typing import Dict, List, Optional
from datetime import datetime

class ValidationError(Exception):
    """Custom exception for validation errors."""
    pass

class UserManager:
    """Manages user operations for the demo application."""
    
    def __init__(self):
        self.users = {}
        self.logger = logging.getLogger(__name__)
    
    def validate_email(self, email: str) -> bool:
        """Validate email format."""
        import re
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return re.match(pattern, email) is not None
    
    def validate_password(self, password: str) -> bool:
        """Validate password strength."""
        if len(password) < 8:
            return False
        if not any(c.isupper() for c in password):
            return False
        if not any(c.islower() for c in password):
            return False
        if not any(c.isdigit() for c in password):
            return False
        return True
    
    def add_user(self, username: str, email: str, password: str, role: str = "user") -> bool:
        """Add a new user to the system."""
        # Validate inputs
        if not username or len(username) < 3:
            raise ValidationError("Username must be at least 3 characters long")
        
        if not self.validate_email(email):
            raise ValidationError("Invalid email format")
        
        if not self.validate_password(password):
            raise ValidationError("Password must be at least 8 characters with uppercase, lowercase, and digit")
        
        if username in self.users:
            self.logger.warning(f"User {username} already exists")
            return False
        
        # Hash password for security
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        
        self.users[username] = {
            "email": email,
            "password_hash": hashed_password,
            "role": role,
            "created_at": datetime.now().isoformat(),
            "status": "active"
        }
        self.logger.info(f"User {username} added successfully")
        return True
    
    def authenticate_user(self, username: str, password: str) -> bool:
        """Authenticate a user with username and password."""
        user = self.users.get(username)
        if not user:
            return False
        
        hashed_password = hashlib.sha256(password.encode()).hexdigest()
        return user["password_hash"] == hashed_password
    
    def get_user(self, username: str) -> Optional[Dict]:
        """Get user information."""
        return self.users.get(username)
    
    def list_users(self) -> List[str]:
        """List all usernames."""
        return list(self.users.keys())

class DataProcessor:
    """Processes data for the demo application."""
    
    def __init__(self):
        self.data = []
        self.logger = logging.getLogger(__name__)
    
    def validate_data_item(self, item: Dict) -> bool:
        """Validate data item structure."""
        required_fields = ["type", "value"]
        return all(field in item for field in required_fields)
    
    def add_data(self, item: Dict) -> None:
        """Add data item to the processor."""
        if not self.validate_data_item(item):
            raise ValidationError("Data item must contain 'type' and 'value' fields")
        
        self.data.append(item)
        self.logger.info(f"Added data item: {item}")
    
    def process_data(self) -> List[Dict]:
        """Process all data items."""
        processed = []
        for item in self.data:
            processed_item = {
                "id": len(processed) + 1,
                "data": item,
                "processed_at": datetime.now().isoformat()
            }
            processed.append(processed_item)
        return processed

def main():
    """Main application entry point."""
    print("MCP Demo Test Application")
    print("=========================")
    
    try:
        # Initialize components
        user_mgr = UserManager()
        data_proc = DataProcessor()
        
        # Add some sample data with validation
        user_mgr.add_user("admin", "admin@example.com", "Admin123", "admin")
        user_mgr.add_user("user1", "user1@example.com", "Password1", "user")
        user_mgr.add_user("user2", "user2@example.com", "Password2", "user")
        
        data_proc.add_data({"type": "test", "value": 42})
        data_proc.add_data({"type": "demo", "value": "hello"})
        
        # Display results
        print(f"Users: {user_mgr.list_users()}")
        print(f"Processed data: {len(data_proc.process_data())} items")
        
    except ValidationError as e:
        print(f"Validation error: {e}")
    except Exception as e:
        print(f"Unexpected error: {e}")

if __name__ == "__main__":
    main()
EOF

    # Commit the changes
    git add main.py
    git commit -m "feat: Add comprehensive data validation and error handling"
    
    # Push all branches
    git push origin feature/user-authentication
    git push origin feature/data-validation
    
    # Return to main branch
    git checkout main
    
    print_status $GREEN "✅ Test branches and changes created"
}

# Function to create test issues and pull requests
create_test_issues_and_prs() {
    print_status $BLUE "📋 Creating test issues and pull requests..."
    
    cd "$TEST_REPO_DIR"
    
    # Create issue via GitHub API
    local issue_response=$(curl -s -X POST \
        -H "Authorization: token $GITHUB_TOKEN" \
        -H "Accept: application/vnd.github.v3+json" \
        -d "{
            \"title\": \"Add user authentication feature\",
            \"body\": \"This issue tracks the implementation of user authentication with password hashing and validation.\",
            \"labels\": [\"enhancement\", \"security\"]
        }" \
        "https://api.github.com/repos/$GITHUB_USERNAME/$TEST_REPO_NAME/issues")
    
    local issue_number=$(echo "$issue_response" | grep -o '"number":[0-9]*' | head -1 | cut -d: -f2)
    
    if [ -n "$issue_number" ]; then
        print_status $GREEN "✅ Created issue #$issue_number"
        
        # Create pull request
        local pr_response=$(curl -s -X POST \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -d "{
                \"title\": \"Add user authentication feature\",
                \"body\": \"Closes #$issue_number\\n\\nThis PR adds user authentication with password hashing and validation.\\n\\n## Changes\\n- Add password hashing using SHA-256\\n- Implement user authentication method\\n- Add input validation for username and password\\n\\n## Testing\\n- [x] User creation with valid credentials\\n- [x] User authentication\\n- [x] Input validation\\n\\n## Security\\n- Passwords are hashed before storage\\n- Input validation prevents injection attacks\",
                \"head\": \"feature/user-authentication\",
                \"base\": \"main\"
            }" \
            "https://api.github.com/repos/$GITHUB_USERNAME/$TEST_REPO_NAME/pulls")
        
        local pr_number=$(echo "$pr_response" | grep -o '"number":[0-9]*' | head -1 | cut -d: -f2)
        
        if [ -n "$pr_number" ]; then
            print_status $GREEN "✅ Created pull request #$pr_number"
        else
            print_status $YELLOW "⚠️  Failed to create pull request"
        fi
    else
        print_status $YELLOW "⚠️  Failed to create issue"
    fi
    
    print_status $GREEN "✅ Test issues and pull requests created"
}

# Function to display next steps
display_next_steps() {
    print_status $BLUE "🎯 Next Steps for Real Data Testing:"
    echo ""
    print_status $GREEN "1. Update your .env file with GitHub credentials:"
    print_status $YELLOW "   GITHUB_TOKEN=$GITHUB_TOKEN"
    print_status $YELLOW "   GITHUB_USERNAME=$GITHUB_USERNAME"
    echo ""
    print_status $GREEN "2. Start the MCP Gateway stack:"
    print_status $YELLOW "   docker-compose up -d"
    echo ""
    print_status $GREEN "3. Run demos with real data:"
    print_status $YELLOW "   ./scripts/run-demo.sh 1 --real-data"
    print_status $YELLOW "   ./scripts/run-demo.sh 2 --real-data"
    echo ""
    print_status $GREEN "4. Test repository URL:"
    print_status $YELLOW "   https://github.com/$GITHUB_USERNAME/$TEST_REPO_NAME"
    echo ""
    print_status $BLUE "The demos will now analyze real changes, create real PRs, and demonstrate real workflow automation!"
}

# Main execution
main() {
    print_status $BLUE "🚀 Setting up MCP Demo Test Repository"
    print_status $BLUE "======================================"
    echo ""
    
    check_prerequisites
    create_github_repo
    create_sample_code
    setup_git_repository
    create_test_changes
    create_test_issues_and_prs
    
    echo ""
    print_status $GREEN "🎉 Test repository setup completed successfully!"
    echo ""
    
    display_next_steps
}

# Run main function
main
