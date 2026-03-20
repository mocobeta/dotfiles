---
name: create-worktree
description: Create a git worktree under the repository root `worktrees/` directory for an existing branch or for a new branch derived from user input or an issue. Use when asked to make a worktree, prepare an isolated branch workspace, infer a branch name from an issue title/body, or create a branch first and then add the worktree. If neither a branch name nor an issue identifier is given, ask the user what work the agent should do before proceeding.
---

# Create Worktree

Create a worktree at `worktrees/<worktree-name>` from the repository root.

## Inputs

- Accept an explicit branch name when the user provides one.
- Accept an issue identifier when the user wants the branch inferred from the issue title/body.
- Obtain the issue title/body through the Linear MCP server or the GitHub MCP server when the issue lives in one of those systems.
- Accept an explicit base branch when the user provides one.
- If neither branch name nor issue identifier is available, ask one concise question about the work to be done before taking action.

## Workflow

1. Confirm the repository root.
- Run `git rev-parse --show-toplevel` and work from that path.
- Use `<REPOSITORY_ROOT>/worktrees/` as the parent directory.

2. Determine the branch name.
- If the user gave a branch name, use it.
- Otherwise, if the user gave an issue identifier, read the issue title/body from Linear or GitHub through the corresponding MCP server and infer a concise branch name.
- Prefer stable prefixes such as `feature/`, `fix/`, `chore/`, `docs/`, `refactor/`, or `test/` when the issue context makes the type obvious.
- Use `feature/` prefix when the task type is unknown or ambiguous. Do not create a branch without a proper prefix.
- Slugify the descriptive part: lowercase, ASCII when possible, replace spaces and separators with `-`, collapse repeated `-`, trim leading/trailing `-`.
- Keep the branch name short and readable.

3. Determine the base branch.
- Use the user-provided base branch when present.
- Otherwise prefer the repository default branch from `refs/remotes/origin/HEAD` when available.
- If that cannot be determined, fall back to `main`, then `master`.

4. Determine the worktree directory name.
- Infer it from the branch name.
- Replace `/` with `-`.
- Use `<REPOSITORY_ROOT>/worktrees/<inferred-name>`.

5. Check for conflicts before creating anything.
- Ensure `worktrees/` exists; create it if needed.
- Check whether the branch already exists locally with `git show-ref --verify --quiet refs/heads/<branch>`.
- Check whether the branch is already attached to another worktree with `git worktree list --porcelain`.
- Check whether the target worktree path already exists.
- If the target path exists or the branch is already checked out elsewhere, stop and tell the user what conflicts with the request.

6. Create the worktree.
- For an existing branch, run `git worktree add <path> <branch>`.
- For a new branch, create it from the chosen base branch with `git worktree add -b <branch> <path> <base-branch>`.
- Do not commit or push unless the user explicitly asks.

7. Verify the result.
- Run `git -C <path> rev-parse --abbrev-ref HEAD`.
- Run `git worktree list`.
- Optionally run `git -C <path> status --short --branch` when useful for confirmation.

## Issue-Based Branch Inference

- Read the issue title and enough of the body to identify the main task.
- Use the Linear MCP server for Linear issues and the GitHub MCP server for GitHub issues or pull-request-backed tasks.
- Infer a branch type from the task:
  - bug fix -> `fix/...`
  - new feature -> `feature/...`
  - maintenance or tooling -> `chore/...`
  - documentation -> `docs/...`
  - refactor -> `refactor/...`
  - test-only work -> `test/...`
  - other/unknown -> `feature/...`
- Build the slug from the task summary, not from noisy filler words.
- Include the issue number in the branch only when it improves clarity or matches the repository convention.

## Safety Rules

- Never overwrite an existing directory.
- Never detach or remove another worktree unless the user explicitly asks.
- Never guess past missing intent: if there is no branch name and no issue, ask what work the agent should do.
- Prefer local repository facts over assumptions when choosing the base branch.

## Report Back

Report:

- whether the branch was existing or newly created
- the branch name
- the base branch when a new branch was created
- the worktree path
- the exact command or commands used
