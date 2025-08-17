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
# Modified main.py with new functionality

# Enhanced functionality
def enhanced_function():
    print('Enhanced feature added')
