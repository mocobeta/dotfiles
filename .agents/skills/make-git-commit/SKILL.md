---
name: make-git-commit
description: "Use when Codex needs to inspect the current Git working tree, review staged, unstaged, and untracked changes together, summarize the full change, convert that summary into a concise commit message, stage remaining changes, and run git commit."
---

# Make Git Commit

## Overview

Review the current change set based on the actual diff, then create a single commit message that matches the overall change. If the working tree clearly contains multiple unrelated topics, stop and confirm whether the changes should be split instead of forcing them into one commit.

## Workflow

1. Check the repository state.
- `git status --short`
- Review staged and unstaged changes together.
- Treat untracked files as possible commit candidates.

2. Review staged changes.
- `git diff --cached --stat`
- `git diff --cached --name-status`
- Use `git diff --cached` when the patch details matter.

3. Review unstaged changes.
- `git diff --stat`
- `git diff --name-status`
- Use `git diff` when the patch details matter.
- Read untracked files so you understand what they add.

4. Build one summary for the full change.
- Summarize the whole working tree, not just the staged diff or just the unstaged diff.
- Group files by feature, purpose, or change intent first.
- Then write a short factual summary covering what changed and why.

5. Create the commit message.
- Turn the summary into one concise message line.
- Use the imperative mood or a short noun phrase.
- Match the repository's existing commit tone.
- Aim for roughly 72 characters or less.
- Avoid file-name lists, vague prefixes, and AI-sounding phrasing.
- Describe the main purpose of the change.

6. Stage remaining changes and commit.
- If the change is coherent as one commit, use `git add -A` to stage the remaining changes.
- Then run `git commit -m "<message>"`.

## Safety Rules

- Do not commit unrelated changes together. Ask the user what should be included if the working tree looks mixed.
- Confirm before committing generated files or local-only files when their intent is unclear.
- Do not create an empty commit unless the user explicitly asks for one.
- Do not unstage existing staged changes unless the user asks for that.
- Do not decide on the commit message before reviewing the diff.

## Output

- First summarize the key staged, unstaged, and untracked changes.
- Then give a 2-5 line summary of the full change.
- Then give the derived one-line commit message.
- If the user asked for the commit to be executed, stage and commit the changes and report the final commit message and commit SHA.
