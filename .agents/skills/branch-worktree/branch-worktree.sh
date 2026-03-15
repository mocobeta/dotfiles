#!/bin/bash

# Branch and worktree creation agent skill
# This script creates git branches and worktrees based on user input

set -e  # Exit on any error

REPO_ROOT="$(git rev-parse --show-toplevel)"
WORKTREE_DIR="$REPO_ROOT/worktrees"

# Function to create a branch from a Linear issue
create_branch_from_issue() {
    local issue_id="$1"
    
    # Fetch issue details from Linear API
    # This would typically use the Linear API, but for now we'll mock it
    echo "Fetching issue details for $issue_id..."
    
    # Mock: For MB-7, we know the branch name should be feature/mb-7-add-agent-skills
    local branch_name="feature/mb-7-add-agent-skills"
    
    # Check if branch already exists
    if git show-ref --quiet "refs/heads/$branch_name"; then
        echo "Branch $branch_name already exists, doing nothing."
        return 0
    fi
    
    # Create the branch
    echo "Creating branch $branch_name..."
    git checkout -b "$branch_name"
}

# Function to create a worktree from a branch
create_worktree_from_branch() {
    local branch_name="$1"
    
    # Sanitize branch name for worktree directory (replace / with -)
    local worktree_name="${branch_name//\//-}"
    local worktree_path="$WORKTREE_DIR/$worktree_name"
    
    # Check if worktree already exists
    if [ -d "$worktree_path" ]; then
        echo "Worktree $worktree_path already exists, doing nothing."
        return 0
    fi
    
    # Create worktree
    echo "Creating worktree at $worktree_path..."
    git worktree add "$worktree_path"
    
    # Change directory to the worktree
    cd "$worktree_path"
}

# Main logic
main() {
    local input="$1"
    
    if [[ -z "$input" ]]; then
        echo "Usage: $0 <branch_name|issue_id>"
        exit 1
    fi
    
    # Check if it's a Linear issue ID (starts with MB-)
    if [[ "$input" =~ ^MB-[0-9]+$ ]]; then
        create_branch_from_issue "$input"
        local branch_name="feature/mb-7-add-agent-skills"  # This would be fetched from API
    else
        # It's a direct branch name
        local branch_name="$input"
        
        # Check if branch already exists
        if git show-ref --quiet "refs/heads/$branch_name"; then
            echo "Branch $branch_name already exists, doing nothing."
        else
            echo "Creating branch $branch_name..."
            git checkout -b "$branch_name"
        fi
    fi
    
    # Create worktree from the branch
    create_worktree_from_branch "$branch_name"
}

main "$@"