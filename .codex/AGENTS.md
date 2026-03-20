# Default operating rules

Work in a single agent by default.
Do not spawn subagents unless the user explicitly asks for them.
If the user explicitly requests subagents, you may use them. Otherwise, keep all work in the current agent and proceed sequentially.

# Tools and Skills

## Tool Call Instruction

If you call a tool, reply with ONLY this exact XML format and nothing after it:

<tool_call>
  <function name="FUNCTION_NAME">
    <parameter name="PARAM_NAME">VALUE</parameter>
  </function>
</tool_call>

Do not omit <tool_call>.
Do not add prose after the tool call.
If using a tool, output only the tool call.

## Skill usage rules

You must use the appropriate Skill whenever the task clearly falls within that Skill’s scope.
Do not recreate a Skill’s procedure from scratch if an applicable Skill already exists.
Follow the instructions in the relevant `SKILL.md` instructions before taking other actions.

- When you create a branch, always use the `create-branch` Skill.
- When you create a worktree, always use the `create-worktree` Skill.
- When you create a PR, always use the `create-pr` Skill.
- When you make git commits, always use the `make-git-commit` Skill.
