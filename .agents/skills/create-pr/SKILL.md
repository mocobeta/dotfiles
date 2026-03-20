---
name: create-pr
description: Create or prepare a pull request with the repository's expected template and structure. Use when asked to draft a PR title/body, open a pull request, update a PR description, or choose the right PR template for a repository. If the repository has multiple plausible PR templates and it is unclear which one applies, show the options to the user and ask which template to use. If no PR template exists, use sections for What, Why, Changes, and Verification, plus Out-of-scope or References when they add value.
---

# Create PR

Create a pull request body that matches the repository's expected format, then open the PR when the user explicitly asks.

## Workflow

1. Inspect the repository for PR templates.
- Check `.github/pull_request_template.md` first.
- Then check `.github/pull_request_template/`, `.github/PULL_REQUEST_TEMPLATE/`, and other standard template locations.
- If there is exactly one obvious template, use it.
- If there are multiple plausible templates and the correct one is unclear, show the candidate paths to the user and ask which template to use before drafting the PR body.

2. Gather the PR context.
- Identify the base branch, head branch, and whether the user wants a draft PR or a ready PR.
- Review the diff, changed files, commit range, and any linked issue or task context.
- Gather verification details from commands, test output, screenshots, or user-provided evidence.
- Ask only for information that cannot be derived from the repository or the conversation.

3. Draft the PR title.
- Match the repository's title conventions when they are visible in existing PRs, commit history, or templates.
- Prefer a factual title that describes the outcome of the change.
- If a task ID or issue ID clearly belongs in the title, include it.

4. Draft the PR body.
- If a template exists, preserve its headings, order, and any checklists or prompts that should remain.
- Fill the template with concise, factual content derived from the diff and verification results.
- Remove placeholder text that should not ship in the final PR unless the template or repository convention expects it.
- If no template exists, use this default structure:

```markdown
## What

## Why

## Changes

## Verification
```

- Add `## Out-of-scope` when it helps reviewers understand intentional omissions.
- Add `## References` when there are linked issues, specs, dashboards, or related PRs worth citing.

5. Handle ambiguity and missing information.
- If the correct template is unclear, stop and ask the user which template to use.
- If verification details are missing and cannot be inferred, ask the user only for the missing verification facts.
- If the branch is not pushed or the base branch is unclear, surface that before trying to open the PR.

6. Create or update the PR when explicitly requested.
- If the user asked only for drafting, return title candidates and the PR body without creating anything.
- If the user explicitly asked to create the PR, use the appropriate tool for the environment, such as `gh pr create` or a GitHub MCP tool.
- Default to draft PR creation unless the user explicitly asks for ready-for-review behavior.
- If updating an existing PR description, replace the body with the confirmed draft while preserving the selected template structure.

## Template Discovery Rules

- Prefer repository-local templates over general conventions.
- Treat these as common candidates:
  - `.github/pull_request_template.md`
  - `.github/PULL_REQUEST_TEMPLATE.md`
  - `.github/pull_request_template/*.md`
  - `.github/PULL_REQUEST_TEMPLATE/*.md`
  - `docs/pull_request_template.md` only if repository conventions clearly use it
- When more than one candidate could apply, present a short options list with file paths and any obvious cues from the filenames, then ask the user to choose.

## Writing Rules

- Write from observable facts in the diff, tests, and issue context.
- Keep sections concise and reviewer-oriented.
- Avoid vague claims such as "improved stuff" or "various fixes".
- In `Changes`, use flat bullets for concrete modifications.
- In `Verification`, include commands, results, or a clear explanation for why verification was not run.
- In `Out-of-scope`, list nearby changes that were intentionally not included.
- In `References`, link or name the issue, task, PR, or document that gives reviewer context.

## Output

- For draft-only requests, return:
  - title candidate or candidates
  - the PR body
  - any open questions that block finalization
- For creation requests, report:
  - whether the PR was draft or ready
  - the base and head branches
  - the final title
  - the PR URL or number when available
