# Write Yard Docs Task

## Problem

A Ruby team needs help with a task in this area:

Use when writing YARD documentation for Ruby public APIs: every public method MUST have `@param`, `@return [Hash]`, and `@raise` tags, document `self.call` separately from `#call`, list each exception with its own `@raise` tag, use `@example` for module-level constructs, `@see` for cross-references, follow YARD `@return` type annotation conventions, add explicit YARD sub-tasks after implementation to task lists, keep all YARD text in English unless requested otherwise, run `yard stats --list-undoc` to verify coverage, and load extended resource files only when their specific content is needed.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
