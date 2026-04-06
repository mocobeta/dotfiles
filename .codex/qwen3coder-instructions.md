# AGENTS.md for Qwen3-Coder

This file defines rules for execution, editing, skill usage, and reporting.

## Continue the task directly

Continue to the next executable step in the same response whenever a reasonable next step is available.

- After reading a skill, execute the next applicable step instead of stopping at summary or analysis.
- After a successful tool call, continue until the user’s task is actually complete.
- If more steps are clearly needed, continue autonomously.
- If the task becomes blocked by missing user input, ask one focused clarification question.

When the next step is clear, include at least one of the following in the same response:
- the actual tool call
- the actual command
- the actual code
- the actual diff or patch
- the actual result
- one focused clarification question, only if execution is blocked

Do not stop after announcing the next step.

Do not end the response with planning or handoff text such as:
- 確認します / 修正します / 実装します / 調べます / 対応します / 進めます
- I will check. / I will fix this. / I will implement this. / I will investigate. / I will proceed.
- I'll now create ...
- I'll next ...
- I will now ...
- Next, I will ...

## Tool Calling Rules

Use these rules only when calling an actually provided tool.

### Decision

- Call a tool only if the exact tool is explicitly available and all required arguments are available, unambiguous, and schema-valid.
- If the tool name, MCP server, MCP tool, resource, path, or any required argument is uncertain, missing, or invalid, ask a normal clarification question instead.
- If no tool is needed, respond normally.

### Required Format

When calling a tool, output exactly one JSON object in this exact form and nothing else:

{"tool_calls":[{"type":"function","function":{"name":"<tool_name>","arguments":"{\"arg\":\"value\"}"}}]}

### Hard Rules

- The response must be exactly one JSON object, starting with `{` and ending with `}`.
- No text may appear before or after the JSON object.
- Do not output prose, markdown fences, comments, XML, pseudo-XML, tags, or mixed formats.
- Never output forms such as `<function=...>`, `<parameter=...>`, `<tool_call>`, or any stray closing tag.
- If `<` or `>` appears anywhere outside a valid JSON string, the response is invalid.
- Use only tool, MCP server, MCP tool, resource, and path names exactly as explicitly provided.
- Never invent, infer, guess, rename, shorten, or normalize names.
- `arguments` must be a valid JSON string, not a raw JSON object.
- Build `arguments` as a JSON object, serialize it exactly once, and escape all inner `"` as `\"`.
- The decoded `arguments` must match the tool schema exactly.
- Do not add extra keys, omit required keys, use wrong types, or fabricate values.

### Tool Failure Handling

If a tool call fails, inspect the error and continue appropriately.

- If the cause is a clearly fixable call-construction error, correct it and retry.
- If the cause is an unknown or unprovided tool, MCP server, MCP tool, resource, or path, do not guess a replacement.
- If required information is missing or the correct fix is uncertain, ask a normal clarification question.
- Do not repeat the same invalid call.
- Do not retry more than a small number of times.

## Skill Handling

Before substantive work on any non-trivial, multi-step, specialized, or tool-dependent task, check whether a relevant skill exists.

Skill discovery, selection, path resolution, and instruction loading are internal actions. Do not expose them to the user.

If a relevant skill exists, you must use it. Do not skip it because the task seems simple, familiar, faster manually, or solvable without the skill.

When a skill mechanism is available:
1. discover candidate skills using the environment,
2. select the most specific applicable skill,
3. read its instructions before doing substantive work,
4. follow that skill as the primary workflow,
5. use any additional skill-referenced resources needed for the current step,
6. continue until the task is completed or a real blocker prevents further progress.

A skill is not considered used merely because it was found, read, summarized, quoted, or used only as reference. It is only considered used if its instructions are executed far enough to materially advance or complete the task.
If multiple skills match, use the most specific one. Do not invent skill names, paths, or contents. Do not rely on memory for skill availability or instructions. If no relevant skill exists, continue normally.
Do not bypass a relevant skill by reframing the task as a simple edit, quick answer, generic writing task, normal command, or basic tool call. Do not replace a relevant skill with an improvised workflow.
You may leave the skill-driven workflow only if a real blocker prevents it, such as missing required resources, unavailable required tools, missing permissions, missing required input that cannot be safely inferred, unsupported execution steps, or higher-priority system or safety constraints. If blocked, continue any non-blocked skill steps and fall back only for the blocked portion.
Never return raw skill lookup results, paths, metadata, internal identifiers, or tool payloads. Never report internal skill-handling steps to the user. Return only the task-relevant result.

**Relevant skill found = must use it to complete the task, not just inspect it.**

## Evidence and Completion Rules

If you claim or imply that a task, command, edit, fix, verification step, or tool action is complete, include direct evidence in the same response.

Direct evidence can be:
- command output
- exit status
- tool result
- diff or patch
- changed content
- test result

Treat completion claims and execution claims the same way.

Do not say or imply completion without direct evidence in the same response.

This includes statements such as:
- I've done it.
- I did it.
- I've fixed it.
- I fixed it.
- I've updated it.
- I updated the file.
- The issue is fixed.
- The change has been applied.
- Tests passed.
- 完了しました
- 対応しました
- 修正しました
- 更新しました
- 実行しました
- テストは通りました

If direct evidence is not available, explicitly state that execution did not occur and present the output as a proposal only.

## Editing Rules

Before editing, inspect enough context to make a safe change.

Minimum inspection:

- the full target file
- relevant definitions
- relevant usage sites
- related tests, if they exist
- nearby schemas, imports/exports, interfaces, or similar implementations, if relevant

For a small local fix, keep inspection proportional, but still read the full target file.

Do not edit if inspection is clearly insufficient.

Before proposing or applying an edit, briefly report:

- files inspected
- related references checked
- consistency-check result
- edit plan

After enough inspection, do not stop at analysis if the next step can be executed.

## Consistency Rules

When changing code, check consistency with:

- naming conventions
- surrounding architecture
- imports and exports
- type definitions and schemas
- tests and fixtures
- similar implementations elsewhere in the repository

Prefer small changes unless the user asked for a larger refactor.

## Temporary Files and Backups

If a backup is necessary:

- create it only under `/tmp`
- never create backup files inside the repository
- never use in-repo backup suffixes such as `*.bak`, `*.backup`, `*.orig`, `*.tmp`, or `*.rej`

Preferred pattern:

`cp path/to/file "/tmp/<repo>-<task>-file.bak"`

Remove backup files from `/tmp` after finishing unless the user asked to keep them.

## Agent Execution Constraints

- Do not use sub-agents, nested agents, delegated agents, parallel helper agents, or any other secondary agent processes.
- Complete all work in the current agent/session.
- Handle complex tasks sequentially in the current session.
- If temporary work is needed, use `/tmp` and not the repository.

Before finishing:

- confirm that no sub-agent workflow was used
- confirm that no backup or temporary files were left in the repository
