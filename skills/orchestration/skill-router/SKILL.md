---
name: skill-router
license: MIT
description: >
  Triages and decomposes complex Ruby requests into ordered sub-tasks and routes each to
  the correct specialised skill. First response line MUST be
  "Next skill: skills/[category]/[name]". Priority order:
  TDD→Planning→Domain discovery→Process/refactor→Domain implementation.
  Fallback to `test-planning-process` when the first failing test is not obvious,
  `define-domain-language` for terminology ambiguity, or `model-domain` for architectural
  ambiguity. Enforces TDD discipline across all code-producing work; no implementation
  code until a failing test exists. Use when scope of a Ruby task is unclear,
  best approach uncertain, or the request spans multiple concerns — not for tasks that
  clearly belong to a single sub-skill already. All output in English.
  Trigger: where do I start with this Ruby feature, help me plan a Ruby feature,
  break down this Ruby task, what's the best approach for this Ruby problem,
  not sure how to approach this Ruby work, multi-step Ruby task, complex Ruby task,
  what should I do first in Ruby.
metadata:
  user-invocable: "true"
  version: 1.0.0
  keywords: ruby, tdd, testing, code-review, ddd, orchestration, entry-point
  origin: "Extracted from igmarin/rails-agent-skills v5.1.17"
---
# Skill Router

## HARD-GATE

```text
Non-negotiable: no implementation code until a test exists, runs, and fails for the right reason (feature missing, not config/syntax).
```

## Core Process

Triages and decomposes any Ruby request into ordered sub-tasks, then delegates to the correct specialized skill.

Identify the matching skill from the table below. **Make the routing statement the first substantive line of every response** (see Output Style for the required format), then proceed.

### Core Skills Catalog

| Skill | Use when... | Notes |
| ----- | ----------- | ----- |
| **define-domain-language** | Extracting ubiquitous language or glossary definitions | Default fallback for ambiguous requirements or terminology confusion |
| **review-domain-boundaries** | Auditing context boundaries and language leakage | Use when auditing boundaries *between* subsystems, not for standard code review |
| **model-domain** | Tactical DDD design (aggregates, entities, value objects, domain services) | Fallback when architecture is the source of ambiguity |
| **write-yard-docs** | Writing or reviewing inline YARD documentation for public Ruby APIs | |
| **create-service-object** | Creating a service object (PORO `.call` pattern) | |
| **implement-calculator-pattern** | Implementing polymorphic variant-based calculators (Strategy + Factory) | |
| **integrate-api-client** | Designing HTTP integrations (layered client/fetcher/builder pattern) | |
| **triage-bug** | Investigating a bug, reproducing via failing test, and creating a repair plan | Primary entry point for bug fixes |
| **respond-to-review** | Receiving code review feedback and addressing comments | |
| **tdd-process** | General engineering loop: Red-Green-Refactor process gates and checkpoints | Use to *execute* the loop; see test-planning-process to map *what* to test |
| **refactor-process** | Safely refactoring code while preserving behavior under characterization tests | |
| **review-process** | Reviewing changesets (severity taxonomies, structured findings, re-review) | Use for standard code review of a specific changeset |
| **security-review-process** | Reviewing code for general Ruby security flaws (secrets, injections) | |
| **test-planning-process** | Choosing test boundaries (unit vs integration) and test scenarios | Use when the first failing test is not obvious; maps *what* to test |

### Skill Priority

When multiple skills could apply, state this priority rule immediately after the routing statement:

```text
Priority: TDD → Planning → Domain discovery → Process/refactor → Domain implementation.
```

**Fallback for ambiguous requests:** If no clear skill match, label this explicitly as `Fallback: define-domain-language` or `Fallback: model-domain` depending on whether terminology or architecture is the source of ambiguity.

### Typical Workflows

Sub-skills are invoked by stating their name as the next skill to apply (see **Output Style**) before proceeding with that skill's instructions.

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

1. **Routing statement**: First substantive line of every response. For a single skill:

   ```text
   Next skill: skills/process/tdd-process

   This is a feature request. I will start by writing a failing test scenario.
   ```

   When multiple skills apply, immediately follow the routing line with one concise priority/chain statement before any analysis or implementation:

   ```text
   Next skill: skills/process/security-review-process
   Priority: security-review-process > review-process; Chain: security-review-process then review-process.

   This pull request contains custom parser rules and input validation, so we will perform a security review first followed by general code review.
   ```

2. **Language**: Generated artifacts and output MUST be in English unless explicitly requested otherwise.
