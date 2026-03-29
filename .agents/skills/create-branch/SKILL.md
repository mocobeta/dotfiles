---
name: create-branch
description: Create a new git branch from a user-provided base branch or from the repository default branch when no base is given. Use when asked to create a branch, prepare a branch for a task, infer a branch name from an issue title/body, or create a task branch before other work begins. If neither a branch name nor an issue identifier is given, ask the user what work the agent should do before proceeding.
---

# Create Branch

Create a local branch from the repository root.

## Inputs

- Accept an explicit branch name when the user provides one.
- Accept an issue identifier when the user wants the branch inferred from the issue title/body.
- Obtain the issue title/body through the Linear MCP server or the GitHub MCP server when the issue lives in one of those systems.
- Accept an explicit base branch when the user provides one.
- If neither branch name nor issue identifier is available, ask one concise question about the work to be done before taking action.

## Workflow

1. Confirm the repository root.
- Run `git rev-parse --show-toplevel` and work from that path.

2. Determine the branch name.
- If the user gave a branch name, use it.
- Otherwise, if the user gave an issue identifier, read the issue title/body from Linear or GitHub through the corresponding MCP server and infer a concise branch name.
- Do not use any default or auto-generated branch name suggested by Linear.
- For Linear issues, always ignore Linear’s suggested branch name and regenerate the branch name from the issue title/body using this skill’s required prefix and slug rules.
- Prefer stable prefixes such as `feature/`, `fix/`, `chore/`, `docs/`, `refactor/`, or `test/` when the issue context makes the type obvious.
- Use `feature/` prefix when the task type is not given or ambiguous. Do not create a branch without a proper prefixes.
- Slugify the descriptive part: lowercase, ASCII when possible, replace spaces and separators with `-`, collapse repeated `-`, trim leading/trailing `-`.
- Keep the branch name short and readable.

3. Determine the base branch.
- Use the user-provided base branch when present.
- Otherwise prefer the repository default branch from `refs/remotes/origin/HEAD` when available.
- If that cannot be determined, fall back to `main`, then `master`.

4. Check for conflicts before creating anything.
- Check whether the target branch already exists locally with `git show-ref --verify --quiet refs/heads/<branch>`.
- Check whether a remote branch with the same name already exists when that matters for the workflow.
- If the branch already exists, stop and tell the user instead of silently resetting or reusing it.

5. Create the branch.
- Ensure the base branch exists locally. Fetch only when needed and permitted.
- Create the branch from the chosen base with `git branch <branch> <base-branch>`.
- If the user explicitly wants to switch to it, use `git switch -c <branch> <base-branch>` instead.
- Do not push unless the user explicitly asks.

6. Verify the result.
- Run `git rev-parse --verify <branch>`.
- Run `git branch --list <branch>`.
- When useful, show `git log --oneline -1 <branch>` to confirm the branch tip.

## Branch Naming Policy

- Branch names must always follow this skill’s naming convention.
- Never use Linear’s default auto-generated branch name for an issue.
- When a Linear issue is used as input, ignore any branch name suggested by Linear and generate a new branch name from the issue title/body using this skill’s prefix and slug rules.
- This rule is mandatory and takes precedence over any default branch naming proposed by external systems.

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

- Never reset or recreate an existing branch without explicit user approval.
- Never guess past missing intent: if there is no branch name and no issue, ask what work the agent should do.
- Prefer local repository facts over assumptions when choosing the base branch.
- Do not push, open a PR, or create a worktree unless the user explicitly asks.

## Report Back

Report:

- the branch name
- the base branch
- whether the branch was newly created or already existed
- the exact command or commands used
