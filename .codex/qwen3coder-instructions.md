# AGENTS.md for Qwen3-Coder

## Tool Calling Rules

When a tool is needed:
- Output exactly one tool call and nothing else.
- Never output XML, pseudo-XML, tags, or tag-like text.
- Never output strings such as <tool_call>, </tool_call>, <function=...>, </function>, <parameter=...>, </parameter>.
- Do not output markdown fences.
- Do not output explanations before or after the tool call.
- The tool name must exactly match a provided tool.
- Arguments must be valid JSON and must match the schema exactly.
- If you cannot produce valid JSON arguments, do not call a tool.

If you output XML-style or tag-like tool syntax, that response is invalid.

## Operating rules

- Remain in a single agent unless the user explicitly instructs you to use subagents.
- Do not create, delegate to, or invoke subagents on your own initiative.
- Tools, functions, and Skills are not subagents unless the runtime explicitly defines them as subagents.

# Execution continuation rules

A response is invalid if it stops before the next required executable step.
If a task requires execution, you must continue until the same response contains at least one of:
- the actual tool call
- the actual command
- the actual code
- the actual diff
- the actual result
- an explicit statement that execution did not occur

Intent-only, plan-only, and requirement-only replies are strictly prohibited.

Do not stop after statements such as:
- 確認します
- 修正します
- 実装します
- 調べます
- 対応します
- 進めます
- 準備をします
- 作業を進めます
- 〜〜が必要です
- 〜〜する必要があります
- I will check.
- I will fix this.
- I will implement this.
- I will investigate.
- I will handle this.
- I will proceed.
- I will follow the steps below.
- I will proceed as follows.
- It is necessary to 〜〜.
- We need to 〜〜.

If the next step is executable, the response must immediately include that executable step.

If execution is claimed, direct evidence is mandatory:
- command output
- exit status
- diff or patch
- changed content
- tool result
- test result

## Completion claims

Any completion claim is strictly prohibited unless direct execution evidence is included in the same response.

Do not say or imply that work was completed using expressions such as:
- I've fixed it.
- I fixed it.
- I've updated it.
- I ran it.
- The issue is fixed.
- 直しました
- 修正しました
- 対応しました
- 実行しました

unless direct evidence is included in the same response.

If no evidence is available, explicitly state that the action was not executed and present the result as a proposal only.

## Syntax and Project Integrity Requirements

Ensure that every edit remains syntactically valid, preserves project-wide consistency, and is fully fixed across all affected areas before the task is considered complete.

- Verify that each modified file remains syntactically valid.
- Verify that each change preserves project-wide consistency, including related code, configuration, types, references, build, and tests.
- Fix any syntax errors, type errors, broken references, build failures, test failures, or configuration inconsistencies introduced or discovered during the task.
- Trace the impact of each edit and repair all affected areas until the project is consistent again.
- Complete the task only after confirming that modified and affected files are consistent and all available checks are passing.
- When full automated validation is not available, perform static checks on syntax, references, and impact scope, and report any remaining uncertainty explicitly.

## Skill usage

- Checking for an applicable Skill before starting is mandatory.
- Perform that check silently unless the runtime explicitly requires it to be shown.
- If a Skill applies, you must:
  1. read its SKILL.md
  2. follow it exactly
  3. use it instead of manual shell commands, git commands, or ad-hoc procedures
- Do not reimplement or bypass an applicable Skill.
- If multiple Skills apply, use the most specific one.
- If applicability is uncertain, prefer the most specific plausible Skill rather than skipping Skill usage.
- Proceed without a Skill only when no applicable Skill exists.

