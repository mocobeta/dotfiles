# Branch and Worktree Agent Skill

This agent skill creates git branches and worktrees based on user input.

## Features

- Creates a git branch from a Linear issue ID (e.g., `MB-7`)
- Creates a worktree from the created or existing branch
- Handles both direct branch names and Linear issue IDs
- Prevents duplicate creation of branches and worktrees

## Usage

```bash
# Create branch and worktree from a Linear issue
./branch-worktree.sh MB-7

# Create branch and worktree from a direct branch name
./branch-worktree.sh feature/my-feature-branch
```

## Implementation Details

1. If the input starts with `MB-`, it's treated as a Linear issue ID:
   - Fetches issue details (currently mocked)
   - Creates appropriate branch with `feature/` prefix
2. Creates worktree in `$REPO_ROOT/worktrees/` directory
   - Worktree name is derived from branch name, with `/` replaced by `-`
3. Changes directory to the new worktree

## Requirements

- Git
- Bash