---
name: research-lib-usage
description: Research how to use a tool, library, SDK, framework, CLI, or API by consulting live tool-backed sources instead of answering from memory. Use when the user asks for usage instructions, setup steps, examples, options, migration guidance, or troubleshooting for a technology and the answer must come from Context7 first, with Ollama Search MCP as the fallback when Context7 is unavailable or does not provide the needed information.
---

# Research Library Usage

Use tool-backed research only. Do not answer from model knowledge alone.

## Workflow

1. Identify the exact thing to research: library, framework, CLI, API, SDK, or tool feature.
2. Try Context7 first.
3. If Context7 returns relevant documentation, answer from that material.
4. If Context7 is unavailable, not enabled, fails to resolve the library, or does not provide enough relevant information, use `ollama_search`.
5. Cite which source path was used in the answer: `Context7` or `Ollama Search`.

## Context7 First

Use Context7 as the default source for technical usage questions.

1. Resolve the library ID with the Context7 library resolver unless the user already provided a valid Context7 library ID.
2. Select the best match from the resolver results.
3. Query Context7 docs with a focused question that names the concrete task.
4. If Context7 returns enough information to answer, stop there and answer from Context7.

### Detailed Context7 Procedure

Follow this sequence whenever Context7 is available:

1. Call `resolve_library_id` with:
   - `libraryName`: the library, framework, SDK, CLI, or tool name from the user request
   - `query`: the user's full question so Context7 can rank matches against the actual task
2. Select the best Context7 match using these rules:
   - prefer the exact or closest package or framework name
   - prefer official or primary documentation over community forks
   - prefer stronger documentation quality signals when multiple close matches exist
   - if the user specifies a version, prefer a versioned Context7 library ID when available
3. Call `query_docs` with:
   - `libraryId`: the selected Context7 library ID
   - `query`: the user's concrete task, not a broad keyword
4. Build the answer from the returned documentation:
   - answer the exact question the user asked
   - include commands, API calls, configuration, or code examples when the docs provide them
   - mention version details when they materially affect the answer

### What To Ask Context7 For

Prefer exact usage guidance such as:

- installation or setup
- initialization
- common API calls
- configuration
- examples
- version-specific behavior
- migration notes
- troubleshooting steps

Use the user's actual task wording whenever possible. Avoid broad prompts like `react hooks` when the real task is `how to fetch data in a React Server Component`.

### Context7 Decision Notes

- If the user already gives a valid Context7 library ID such as `/vercel/next.js`, skip resolution and query docs directly.
- If the resolver returns several plausible matches, choose the one that best matches the user intent instead of trying multiple libraries by default.
- If the returned docs are clearly partial but still usable, answer only the supported part and state what Context7 did not cover.

### Context7 Coverage Priorities

When Context7 is sufficient, prefer answering from these doc-backed areas:

   - installation or setup
   - initialization
   - common API calls
   - configuration
   - examples
   - version-specific behavior
   - migration notes

## When To Fall Back To Ollama Search

Use `ollama_search` when any of the following is true:

- Context7 MCP is not available or not enabled.
- The library cannot be resolved confidently in Context7.
- Context7 returns no relevant documentation for the requested task.
- Context7 results are too incomplete to answer the user safely.

When using `ollama_search`, search for the exact tool and task rather than a broad topic. Prefer official documentation, primary sources, or authoritative project pages in the returned results when available.

## Answer Rules

- Never answer from memory alone.
- Never skip the Context7 attempt when Context7 is available.
- If Context7 succeeds, do not use `ollama_search` just to add extra color.
- If you must fall back, state that Context7 was unavailable or insufficient.
- Keep the answer focused on the user’s task and include concrete commands, code, or steps when the source supports them.
- If neither Context7 nor `ollama_search` yields enough information, say that the research was insufficient instead of filling gaps from memory.

## Output Format

Structure the answer in compact prose or short bullets as appropriate, and include:

- what was researched
- which source path was used
- the actual usage guidance
- any important assumptions or version caveats
- a brief note if the available research was incomplete

## Example Triggers

- "How do I use this npm package?"
- "Look up the latest way to configure this SDK."
- "Find how to initialize this library in Python."
- "Research how this CLI subcommand works."
- "Check the docs for this framework feature."
