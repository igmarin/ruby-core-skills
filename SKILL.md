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
| **tdd-process** | Process | General engineering loop: Red-Green-Refactor process gates and checkpoints. |
| **refactor-process** | Process | Safely refactoring code while preserving behavior under characterization tests. |
| **review-process** | Process | Reviewing changesets (severity taxonomies, structured findings, re-review). |
| **security-review-process** | Process | Reviewing code for general Ruby security flaws (secrets, injections). |
| **test-planning-process** | Process | Choosing test boundaries (unit vs integration) and test scenarios. |

---

## 1. Process-Discipline Skills (5)

Process-discipline skills encode universal software engineering principles. They contain zero framework-specific details and are meant to be referenced by framework agents to enforce engineering gates.

- [tdd-process](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/process/tdd-process/SKILL.md): Standardizes the Red-Green-Refactor loop.
- [refactor-process](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/process/refactor-process/SKILL.md): Guides safe code cleanups under tests.
- [review-process](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/process/review-process/SKILL.md): Defines severity levels and structures feedback.
- [security-review-process](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/process/security-review-process/SKILL.md): Focuses on general Ruby threat vectors.
- [test-planning-process](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/process/test-planning-process/SKILL.md): Decision grid for test scopes and cases.

## 2. Atomic Skills (10)

Atomic skills focus on concrete Ruby programming patterns, design patterns, and domain analysis techniques.

- [write-yard-docs](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/docs/write-yard-docs/SKILL.md): Rules for API documentation.
- [create-service-object](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/patterns/create-service-object/SKILL.md): Standardizes PORO service objects.
- [implement-calculator-pattern](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/patterns/implement-calculator-pattern/SKILL.md): Implements Factory + Strategy.
- [integrate-api-client](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/patterns/integrate-api-client/SKILL.md): Layered API clients.
- [define-domain-language](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/ddd/define-domain-language/SKILL.md): Glossary and terms extraction.
- [review-domain-boundaries](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/ddd/review-domain-boundaries/SKILL.md): Evaluates context leakage.
- [model-domain](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/ddd/model-domain/SKILL.md): Identifies aggregates and invariants.
- [triage-bug](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/testing/triage-bug/SKILL.md): Standardizes bug investigations.
- [respond-to-review](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/code-quality/respond-to-review/SKILL.md): Process for receiving PR feedback.
- [skill-router](file:///Users/igmarin/Developer/Personal/Projects/ruby-core-skills/skills/orchestration/skill-router/SKILL.md): Orchestrator entry point.
