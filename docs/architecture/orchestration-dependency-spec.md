# Orchestration Cross-Repo Dependency Specification

> **Status:** Final — Phase 0 Deliverable (Updated for Plan 4)
> **Date:** 2026-06-01
> **Scope:** How framework orchestrators declare and reference skills from `ruby-core-skills` and other repos

---

## 1. Overview

Framework orchestrators (e.g., `skills/testing/practice-tdd/SKILL.md` in `rails-agent-skills`) chain multiple skills into guided, deterministic workflows. When an orchestrator needs a skill from another repo (e.g., `tdd-process` from `ruby-core-skills`), the dependency must be declared explicitly. This document specifies the frontmatter format and body annotation convention for cross-repo skill references.

**Design principle:** Dependencies are declarative, not imperative. The runtime resolves them via pack selection. No hard-coded paths.

---

## 2. Frontmatter Dependency & Workflow Format

### 2.1 Specification

Orchestrator `SKILL.md` files include both a `metadata.dependencies` array and a structured `workflow` definition in their YAML frontmatter.

```yaml
---
name: practice-tdd
type: orchestrator
license: MIT
description: >
  Full TDD feature cycle: plan → test → implement → review → PR
metadata:
  version: 2.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills:
        - load-context
        - plan-tests
        - write-tests
        - code-review
    - source: ruby-core-skills
      skills:
        - tdd-process
        - write-yard-docs
workflow:
  phases:
    - name: plan
      description: "Understand requirements and design test cases"
      actions:
        - name: plan-tests
          purpose: "Draft the test cases and scenarios"
          required_skills: [plan-tests]
          gate: "proposal"
    - name: red-green-refactor
      description: "Execute TDD loop"
      actions:
        - name: write-failing-test
          purpose: "Write test and verify it fails"
          required_skills: [write-tests]
          gate: "test-failure"
        - name: implement
          purpose: "Write minimal implementation code to pass"
          required_skills: [write-tests]
          gate: "test-success"
---
```

### 2.2 Field Definitions

| Field | Type | Required | Description |
|---|---|---|---|
| `type` | string | Yes | Set to `orchestrator` to mark this skill as a workflow. |
| `metadata.dependencies` | array | No | List of dependency groups. Absent = no external dependencies. |
| `metadata.dependencies[].source` | string | Yes | `self` for same-repo skills, or the repo slug (`owner/repo`) for external skills. |
| `metadata.dependencies[].skills` | array | Yes | List of skill canonical names (from `directory.json` keys or `.tessl-plugin/plugin.json` paths). |
| `workflow.phases` | array | Yes | The list of logical phases representing the sequential workflow. |
| `workflow.phases[].actions` | array | Yes | Ordered list of discrete actions to execute in this phase. |
| `workflow.phases[].actions[].required_skills` | array | Yes | Atomic skills needed to complete this action step. |
| `workflow.phases[].actions[].gate` | string | No | Gate or checkpoint validation criteria. |

---

## 3. Body Annotation Convention

### 3.1 Inline References

Within the body of an orchestrator's `SKILL.md`, when referencing a skill from another repo, append `*(from <pack>)*` after the skill name for human readability.

```markdown
### Phase 1: Context & Test Design
1. **load-context**: Load schema, routes, and patterns.
2. **plan-tests**: Choose the best first failing spec.
3. **write-tests**: Write test and verify failure.

**HARD GATE — tdd-process** *(from ruby-core-skills)*:
- Test EXISTS and is RUN.
- FAILS for correct reason.
- If FAIL is incorrect, return to write-tests.

### Phase 4: Finish
1. **write-yard-docs** *(from ruby-core-skills)*: Document public Ruby API.
2. **code-review**: Self-review PR diff.
```

---

## 4. Examples by Orchestrator

### 4.1 Rails `practice-tdd` Orchestrator

```yaml
---
name: practice-tdd
type: orchestrator
license: MIT
description: >
  Full TDD feature cycle: plan → test → implement → review → PR
metadata:
  version: 2.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills:
        - load-context
        - plan-tests
        - write-tests
        - code-review
    - source: ruby-core-skills
      skills:
        - tdd-process
        - write-yard-docs
---
```

### 4.2 Rails `review-code` Orchestrator

```yaml
---
name: review-code
type: orchestrator
license: MIT
description: >
  Systematic PR review: review → deep dive → response
metadata:
  version: 2.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills:
        - code-review
        - respond-to-review
    - source: ruby-core-skills
      skills:
        - review-process
---
```

### 4.3 Rails `improve-code-quality` Orchestrator

```yaml
---
name: improve-code-quality
type: orchestrator
license: MIT
description: >
  Pre-PR quality check: conventions → refactor → docs
metadata:
  version: 2.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills:
        - apply-code-conventions
        - apply-stack-conventions
        - refactor-code
    - source: ruby-core-skills
      skills:
        - refactor-process
        - review-process
        - write-yard-docs
---
```

---

## 5. Rules for Framework Repo Authors

### 5.1 When to Declare Dependencies

| Scenario | Action |
|---|---|
| Orchestrator chains a skill from core | Add to `dependencies` with `source: ruby-core-skills` |
| Skill's Integration table references a core skill | No frontmatter change needed; annotate body with `*(from ruby-core-skills)*` |
| Orchestrator chains only same-repo skills | Omit `dependencies` or use only `source: self` |

### 5.2 Orchestrator SKILL.md Update Checklist

- [ ] Frontmatter includes `type: orchestrator` and `workflow` blocks.
- [ ] Frontmatter includes `metadata.dependencies` with all cross-repo skills.
- [ ] Body annotations use `*(from ruby-core-skills)*` for first mention of each core skill.
- [ ] Integration tables updated to reference core process skills where applicable.
- [ ] Orchestrator workflow diagram (if present) updated to show core skill boundaries.

---

## 6. Runtime Dependency Resolution Flow

```text
1. User invokes workflow: agent-mcp-runtime --pack rails use_skill practice-tdd
2. Runtime loads orchestrator SKILL.md from rails pack
3. Runtime parses metadata.dependencies and workflow
4. For each dependency:
   a. Resolve source to a pack (self → rails, ruby-core-skills → core)
   b. Load skill from that pack into context
5. Orchestration execution begins with all declared skills loaded
```
