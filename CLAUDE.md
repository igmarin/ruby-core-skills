# Ruby Core Skills — Claude Code Context

This repository provides a library of specialized, framework-agnostic Ruby development skills. When a task arrives, check if any skill applies and read it before responding.

## CROSS-CUTTING MANDATE: Tests Gate Implementation

```text
THIS IS NON-NEGOTIABLE AND APPLIES TO EVERY SKILL THAT PRODUCES CODE.

WORKFLOW: TASK/FEATURE → TESTS → IMPLEMENTATION → YARD → DOCS → CODE REVIEW → PR

Tests are a GATE. Implementation code CANNOT be written until:
1. The test EXISTS
2. The test has been RUN
3. The test FAILS for the right reason (feature missing, not a typo)
```

Wrote implementation code before the test? Delete it. Start over. No exceptions.

## Primary Workflow: TDD Feature Loop

Workflows are built from atomic process building blocks. The standard TDD loop:

```text
test-planning-process → write failing test
  → [CHECKPOINT: Test Feedback — confirm behavior, boundary, edge cases]
  → [CHECKPOINT: Implementation Proposal — confirm approach before coding]
  → tdd-process (minimal code to pass test) → refactor-process
  → [GATE: Linters + Full Test Suite]
  → write-yard-docs
  → review-process (self-review)
  → respond-to-review (when feedback is received)
```

## Available Skills

Skills are located in subdirectories under `skills/`. Read the relevant `SKILL.md` before responding to any task that matches.

### Process Discipline

| Skill | Use when... |
|---|---|
| `tdd-process` | Standardizing the Red-Green-Refactor loop. |
| `refactor-process` | Safely restructuring code under passing tests. |
| `review-process` | Reviewing changesets (severity taxonomies, structured findings). |
| `security-review-process` | Checking code for general Ruby threat vectors. |
| `test-planning-process` | Planning test boundaries and scenarios. |

### Atomic Ruby Skills

| Skill | Use when... |
|---|---|
| `write-yard-docs` | Documenting public Ruby interfaces with Param/Return/Raise tags. |
| `create-service-object` | Standardizing PORO service object classes with `.call`. |
| `implement-calculator-pattern` | Building variant-based calculators (Strategy + Factory). |
| `integrate-api-client` | Writing layered API integrations (Auth, Client, Fetcher, Builder, Entity). |
| `define-domain-language` | Extracting ubiquitous language or glossary definitions. |
| `review-domain-boundaries` | Auditing context boundaries and language leakage. |
| `model-domain` | Tactical DDD design (aggregates, entities, value objects). |
| `triage-bug` | Standardizing bug reproduction and repair planning. |
| `respond-to-review` | Evaluating and responding to received PR feedback. |
| `skill-router` | Bootstrapping and routing complex Ruby requests. |

## Core Ruby Code Conventions

- **Basics:** Use `frozen_string_literal: true` on line 1 of every file.
- **YARD Docs:** Write YARD docs in English for all new/modified public interfaces before merging.
- **Style:** Prefer standard Ruby idioms and code style (e.g. Standard Ruby or RuboCop defaults).
- **Language:** All user-facing logs, variables, YARD text, and comments must be in English unless explicitly requested otherwise.
