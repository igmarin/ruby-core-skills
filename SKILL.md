---
name: ruby-core-skills
description: >
  Catalog of 16 shared Ruby development skills covering TDD, refactoring,
  code review, security review, DDD, YARD documentation, and common design
  patterns (service objects, calculators, API clients). Routes to specialized
  skills by category. Use when building Ruby applications, implementing
  TDD workflows, reviewing code, or needing Ruby-specific process discipline.
  Trigger: Ruby development, Ruby skill, Ruby TDD, Ruby code review, Ruby
  design patterns.
---

# AI Skill Catalog — Ruby Core Skills

This repository serves as the central library of framework-agnostic Ruby skills and process-discipline skills for the AI agent ecosystem.

## Skill Catalog Overview

| Skill | Category | Description |
|---|---|---|
| **define-domain-language** | DDD | Extracting ubiquitous language or glossary definitions. |
| **review-domain-boundaries** | DDD | Auditing context boundaries and language leakage. |
| **model-domain** | DDD | Tactical DDD design (aggregates, entities, value objects, domain services). |
| **write-yard-docs** | Documentation | Writing or reviewing inline YARD documentation for public Ruby APIs. |
| **create-service-object** | Patterns | Creating a service object (PORO `.call` pattern). |
| **implement-calculator-pattern** | Patterns | Implementing polymorphic variant-based calculators (Strategy + Factory). |
| **integrate-api-client** | Patterns | Designing HTTP integrations (layered client/fetcher/builder pattern). |
| **triage-bug** | Testing | Investigating a bug, reproducing via failing test, and creating a repair plan. |
| **respond-to-review** | Code Quality | Receiving code review feedback and addressing comments. |
| **skill-router** | Orchestration | Triaging and decomposing complex Ruby requests into ordered sub-tasks. |
| **generate-tdd-tasks** | Planning | Breaking features into TDD quadruplet task lists with docs and review tasks. |
| **tdd-process** | Process | General engineering loop: Red-Green-Refactor process gates and checkpoints. |
| **refactor-process** | Process | Safely refactoring code while preserving behavior under characterization tests. |
| **review-process** | Process | Reviewing changesets (severity taxonomies, structured findings, re-review). |
| **security-review-process** | Process | Reviewing code for general Ruby security flaws (secrets, injections). |
| **test-planning-process** | Process | Choosing test boundaries (unit vs integration) and test scenarios. |

---

## 1. Process-Discipline Skills (5)

Process-discipline skills encode universal software engineering principles. They contain zero framework-specific details and are meant to be referenced by framework agents to enforce engineering gates.

- [tdd-process](./skills/process/tdd-process/SKILL.md): Standardizes the Red-Green-Refactor loop.
- [refactor-process](./skills/process/refactor-process/SKILL.md): Guides safe code cleanups under tests.
- [review-process](./skills/process/review-process/SKILL.md): Defines severity levels and structures feedback.
- [security-review-process](./skills/process/security-review-process/SKILL.md): Focuses on general Ruby threat vectors.
- [test-planning-process](./skills/process/test-planning-process/SKILL.md): Decision grid for test scopes and cases.

## 2. Planning Skills (1)

Planning skills bridge requirements and implementation by breaking features into actionable task lists. They compose process-discipline and atomic skills into ordered workflows.

- [generate-tdd-tasks](./skills/planning/generate-tdd-tasks/SKILL.md): Breaks features into TDD quadruplet task lists with auto-detected project conventions.

## 3. Atomic Skills (10)

Atomic skills focus on concrete Ruby programming patterns, design patterns, and domain analysis techniques.

- [write-yard-docs](./skills/docs/write-yard-docs/SKILL.md): Rules for API documentation.
- [create-service-object](./skills/patterns/create-service-object/SKILL.md): Standardizes PORO service objects.
- [implement-calculator-pattern](./skills/patterns/implement-calculator-pattern/SKILL.md): Implements Factory + Strategy.
- [integrate-api-client](./skills/patterns/integrate-api-client/SKILL.md): Layered API clients.
- [define-domain-language](./skills/ddd/define-domain-language/SKILL.md): Glossary and terms extraction.
- [review-domain-boundaries](./skills/ddd/review-domain-boundaries/SKILL.md): Evaluates context leakage.
- [model-domain](./skills/ddd/model-domain/SKILL.md): Identifies aggregates and invariants.
- [triage-bug](./skills/testing/triage-bug/SKILL.md): Standardizes bug investigations.
- [respond-to-review](./skills/code-quality/respond-to-review/SKILL.md): Process for receiving PR feedback.
- [skill-router](./skills/orchestration/skill-router/SKILL.md): Orchestrator entry point.
