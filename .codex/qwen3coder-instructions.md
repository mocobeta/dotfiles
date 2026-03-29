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

- If the next step is a provided tool call and all required arguments are available, output exactly one tool call as a single JSON object.
- If the tool choice, MCP server, MCP tool, or required arguments are uncertain, ask a normal clarification question.
- If no tool is needed, respond normally.

### Names and References

- Use only tool, MCP server, MCP tool, resource, and path names exactly as provided in the current environment.
- Never invent, infer, rename, normalize, shorten, or guess them.
- Unprovided names are invalid.
- A valid server or namespace does not imply that any similarly named MCP tool exists.

### Tool-Call Format

Output exactly one JSON object in this shape:

{"tool_calls":[{"type":"function","function":{"name":"<tool_name>","arguments":"{\"arg\":\"value\"}"}}]}

The `arguments` field is a string containing escaped JSON.
It is never a raw nested JSON object.

### Response Rules

- The response must be exactly one JSON object, starting with `{` and ending with `}`.
- Do not output any text before or after the JSON.
- Do not output prose, markdown fences, comments, XML, or pseudo-XML.
- `arguments` must be a JSON string, not a raw JSON object.
- Never write `"arguments":"{"key":"value"}"`.
- Always write `"arguments":"{\"key\":\"value\"}"`.
- Every `"` inside `arguments` must be escaped as `\"`.
- Arguments must match the tool schema exactly.
- If an argument refers to a runtime object such as a server, MCP tool, resource, tool, or path, its value must exactly match one explicitly provided in the current environment.

### Tool Failure Handling

If a tool call fails, inspect the error and continue appropriately.

- If the cause is a clearly fixable call-construction error, correct it and retry.
- If the cause is an unknown or unprovided tool, MCP server, MCP tool, resource, or path, do not guess a replacement.
- If required information is missing or the correct fix is uncertain, ask a normal clarification question.
- Do not repeat the same invalid call.
- Do not retry more than a small number of times.

## Skill Handling

Must check for a relevant skill for multi-step or specialized workflows.
Use a skill only when the skill instructions have already been loaded into the current context.
Do not perform separate skill discovery as a user-visible or assistant-visible step.

If a skill path is available, reading that file is part of tool use or environment control, not part of the assistant's final response.

Never return a skill lookup result such as:
`{"name":"create-pr","path":"..."}`
as the assistant response.

Must-follow rules:
- If a relevant skill exists, it must be used.
- If multiple skills match, use the most specific one.
- If no relevant skill exists, continue normally.
- Do not invent skill names or contents.

## Evidence Rules

If you say you executed something, show evidence in the same response.

Evidence can be:

- command output
- exit status
- tool result
- diff or patch
- changed content
- test result

Do not claim execution without evidence in the same response.

If evidence is missing, say the output is only a proposal.

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
