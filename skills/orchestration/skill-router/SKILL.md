---
name: skill-router
license: MIT
description: >
  Triages and decomposes complex Ruby requests into ordered sub-tasks, then delegates to
  specialized skills for testing, code review, DDD, and patterns. Enforces TDD discipline
  across all code-producing work. Use when scope is unclear, the best approach is uncertain, or a
  request spans multiple concerns. Trigger: where do I start, help me plan a Ruby feature,
  break this down, what's the best approach for this Ruby work, not sure how to approach this,
  multi-step Ruby task, complex Ruby task, what should I do first.
metadata:
  user-invocable: "true"
  version: 1.0.0
  keywords: ruby, tdd, testing, code-review, ddd, orchestration, entry-point
  origin: "Extracted from igmarin/rails-agent-skills v5.1.17"
---
# Skill Router

## Quick Reference

| Scenario | Primary Skill |
|----------|---------------|
| Fallback: unfamiliar codebase / ambiguity | `define-domain-language` or `model-domain` |
| Choosing where to start testing | `test-planning-process` |
| Reviewing code | `review-process` |
| Fixing a bug | `triage-bug` |

## HARD-GATE

```text
Non-negotiable: no implementation code until a test exists, runs, and fails for the right reason (feature missing, not config/syntax).
ALWAYS identify the matching skill and name it explicitly as the next skill to use before responding further.
```

## Core Process

Triages and decomposes any Ruby request into ordered sub-tasks, then delegates to the correct specialized skill. Enforces the test-first/TDD mandate across all code-producing work.

When a task arrives, identify the matching skill from the tables below and **name it explicitly as the next skill to use** before responding further.

In an active response, make the routing statement, such as `Next skill: skills/process/tdd-process` or `Next skill: skills/patterns/create-service-object`, the first substantive line before analysis or implementation. When multiple skills may apply, immediately follow the routing line with one concise priority/chain statement, such as `Priority: tdd-process > write-yard-docs; Chain: tdd-process then write-yard-docs`, before any analysis or implementation.

### Core Skills Catalog

| Skill | Use when... |
| ----- | ----------- |
| **define-domain-language** | Extracting ubiquitous language or glossary definitions |
| **review-domain-boundaries** | Auditing context boundaries and language leakage |
| **model-domain** | Tactical DDD design (aggregates, entities, value objects, domain services) |
| **write-yard-docs** | Writing or reviewing inline YARD documentation for public Ruby APIs |
| **create-service-object** | Creating a service object (PORO `.call` pattern) |
| **implement-calculator-pattern** | Implementing polymorphic variant-based calculators (Strategy + Factory) |
| **integrate-api-client** | Designing HTTP integrations (layered client/fetcher/builder pattern) |
| **triage-bug** | Investigating a bug, reproducing via failing test, and creating a repair plan |
| **respond-to-review** | Receiving code review feedback and addressing comments |
| **tdd-process** | General engineering loop: Red-Green-Refactor process gates and checkpoints |
| **refactor-process** | Safely refactoring code while preserving behavior under characterization tests |
| **review-process** | Reviewing changesets (severity taxonomies, structured findings, re-review) |
| **security-review-process** | Reviewing code for general Ruby security flaws (secrets, injections) |
| **test-planning-process** | Choosing test boundaries (unit vs integration) and test scenarios |

### Skill Priority

When multiple skills could apply, state this priority rule immediately after the routing statement:

```text
Priority: TDD → Planning → Domain discovery → Process/refactor → Domain implementation.
```

Use `test-planning-process` when the first failing test is not obvious.

**Key disambiguation signals:**
- `review-process` vs `review-domain-boundaries`: use review-domain-boundaries when auditing boundaries between subsystems; use review-process when doing a standard code review of a specific changeset.
- `test-planning-process` vs `tdd-process`: use test-planning-process when mapping *what* scenarios and boundaries to test; use tdd-process to execute the Red-Green-Refactor loop.

**Fallback for ambiguous requests:** If no clear skill match, label this explicitly as `Fallback: define-domain-language` or `Fallback: model-domain` depending on whether terminology or architecture is the source of ambiguity.

### Typical Workflows

Sub-skills are invoked by stating their name as the next skill to apply, e.g. *"Next skill: skills/process/tdd-process"*, before proceeding with that skill's instructions.

**TDD Feature Loop** *(primary daily workflow)*:
skills/process/test-planning-process → skills/process/tdd-process → skills/docs/write-yard-docs → PR

**Bug fix:**
skills/testing/triage-bug → **[GATE: reproduction test fails]** → skills/process/tdd-process → fix → verify passes

**Multi-concern review:**
skills/process/security-review-process *(if input/secrets touched)* → skills/process/review-process *(general code review)*

## Extended Resources

- [assets/examples.md](assets/examples.md) — Routing examples.
- [assets/workflows.md](assets/workflows.md) — Extended workflow definitions.
- [assets/skill-map.json](assets/skill-map.json) — Schema of core skill triggers.

## Output Style

1. **Routing statement**: Clearly state the next skill being invoked as the first substantive line of the response.

   ```text
   Next skill: skills/process/tdd-process
   
   This is a feature request. I will start by writing a failing test scenario.
   ```

   Put this routing statement before any deeper analysis. If multiple skills apply, immediately follow it with one concise priority/chain statement before analysis or implementation:

   ```text
   Next skill: skills/process/security-review-process
   Priority: security-review-process > review-process; Chain: security-review-process then review-process.
   
   This pull request contains custom parser rules and input validation, so we will perform a security review first followed by general code review.
   ```

2. **Language**: Generated artifacts and output MUST be in English unless explicitly requested otherwise.

## Integration

| Skill | When to chain |
|-------|---------------|
| **define-domain-language** | Default for ambiguous requirements |
