# Ruby Core Skills — Orchestration Guidance

This file tells AI agents and runtimes how to use this repository effectively.

## What This Repository Is

A curated library of 16 public skills (atomic, process-discipline, and planning) for Ruby development, with **zero orchestrator workflows**. Each skill encodes specialized workflow knowledge, conventions, and checkpoints/gates for general Ruby development. Skills are not documentation — they are executable instructions that guide agents through structured workflows.

This repository serves as a foundational library. Framework-specific repositories (such as `rails-agent-skills` and `hanakai-yaku`) contain orchestrator skills (workflows) that compose and chain skills from this repository.

## How Skills Are Organized

Each skill lives at `skills/<name>/SKILL.md`:

```text
skills/<skill-name>/
├── SKILL.md          # Entry point — always read this first
├── EXAMPLES.md       # Concrete input/output examples (when present)
├── TESTING.md        # Test templates and spec checklists (when present)
└── assets/           # Schemas, templates, and reference resources
```

Read `SKILL.md` first. Load supporting files only when the skill links to them and the content is needed.

## Skill Selection

Load the skill that best matches the current task. The bootstrap skill `skill-router` routes to specialized skills. Layout is flat (`skills/<name>/`). Display groups live in `skills.sh.json`.

| Category | Skills | Type |
|----------|--------|------|
| **Docs** | `write-yard-docs` | Atomic |
| **Patterns** | `create-service-object`, `implement-calculator-pattern`, `integrate-api-client` | Atomic |
| **DDD** | `define-domain-language`, `review-domain-boundaries`, `model-domain` | Atomic |
| **Testing** | `triage-bug` | Atomic |
| **Code Quality** | `respond-to-review` | Atomic |
| **Orchestration** | `skill-router` | Atomic |
| **Planning** | `generate-tdd-tasks` | Atomic |
| **Process** | `tdd-process`, `refactor-process`, `review-process`, `security-review-process`, `test-planning-process` | Process Rule |

## Non-Negotiable Workflow Rule

**Tests gate implementation.** This applies to every skill that produces code:

```
Write test → Run test → Verify it FAILS for the right reason → Implement → Verify it PASSES
```

Do not write implementation code before the test exists and fails. Every skill that produces code contains a `HARD-GATE` section enforcing this. Honor it.

## Output Language

All outputs (code comments, YARD docs, reports, and response text) must be in English unless the user explicitly requests otherwise.
