# Ruby Core Skills — Gemini CLI Configuration

This file provides equivalent instructions to `CLAUDE.md` for Gemini CLI.

## Repository Purpose

`ruby-core-skills` is a curated library of atomic and process-discipline skills for general Ruby development. It teaches AI coding agents (and developers) how to plan, implement, test, and review Ruby code using framework-agnostic conventions.

This repository serves as a foundational library. Framework-specific repositories contain agents that compose and chain skills from this repository.

## Skill Catalog

The repository contains 15 skills covering:

- **Process Discipline**: `tdd-process`, `refactor-process`, `review-process`, `security-review-process`, `test-planning-process`
- **Atomic Ruby Skills**: `write-yard-docs`, `create-service-object`, `implement-calculator-pattern`, `integrate-api-client`, `define-domain-language`, `review-domain-boundaries`, `model-domain`, `triage-bug`, `respond-to-review`, `skill-router`

## How to Discover Skills

1. **MCP Server** (preferred): The `agent-mcp-runtime` server exposes `list_skills` and `use_skill` tools. Load skills on demand to keep context small.
2. **Direct file reference**: Reference skills by canonical `name` from frontmatter.
3. **GitHub CLI**: `gh skill install igmarin/ruby-core-skills <canonical-name>`

## How to Invoke a Skill

Reference skills by their canonical `name` from YAML frontmatter:

- `write-yard-docs`
- `create-service-object`
- `tdd-process`
- `refactor-process`

File paths (for reference only):
- `skills/docs/write-yard-docs/SKILL.md`
- `skills/patterns/create-service-object/SKILL.md`
- `skills/process/tdd-process/SKILL.md`
- `skills/process/refactor-process/SKILL.md`

## TDD Gate Enforcement

For all code-producing tasks, enforce the TDD Gate:

1. Write a failing test
2. Run the test and verify it fails for the right reason
3. Implement the minimal code to make it pass
4. Run the test and verify it passes
5. Refactor if needed

No exceptions. Tests gate implementation.

## Gemini-Specific Conventions

When working with Gemini CLI, use `/skill-name` syntax to explicitly invoke a skill:

```text
/create-service-object — How do I implement a new service class?
/tdd-process — I need to implement a new feature step-by-step
```

Or simply describe the task and the agent will load the appropriate skill automatically via MCP.

## Progressive Disclosure

When loading skills:
1. **Discovery**: Load only the name and description of each skill
2. **Activation**: When a task matches a skill's description, read the full SKILL.md
3. **Execution**: Follow the instructions, optionally executing bundled code or loading referenced files
