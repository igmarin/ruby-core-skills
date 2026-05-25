# Agent Cross-Repo Dependency Specification

> **Status:** Final — Phase 0 Deliverable
> **Date:** 2026-05-24
> **Scope:** How framework agents declare and reference skills from `ruby-core-skills` and other repos

---

## 1. Overview

Framework agents (e.g., `agents/tdd` in `rails-agent-skills`) chain multiple skills into guided workflows. When an agent needs a skill from another repo (e.g., `tdd-process` from `ruby-core-skills`), the dependency must be declared explicitly. This document specifies the frontmatter format and body annotation convention for cross-repo skill references.

**Design principle:** Dependencies are declarative, not imperative. The runtime resolves them via pack selection. No hard-coded paths.

---

## 2. Frontmatter Dependency Format

### 2.1 Specification

Agent `SKILL.md` files include a `metadata.dependencies` array in YAML frontmatter. Each entry specifies a source repo and the skills needed from it.

```yaml
---
name: tdd
license: MIT
description: >
  Full TDD feature cycle: test → implement → review → PR
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

### 2.2 Field Definitions

| Field                            | Type   | Required | Description                                                                       |
| ----------------------------------| --------| ----------| -----------------------------------------------------------------------------------|
| `metadata.dependencies`          | array  | No       | List of dependency groups. Absent = no external dependencies.                     |
| `metadata.dependencies[].source` | string | Yes      | `self` for same-repo skills, or the repo slug (`owner/repo`) for external skills. |
| `metadata.dependencies[].skills` | array  | Yes      | List of skill canonical names (from `tile.json` keys).                            |

### 2.3 Source Values

| Value | Meaning | Resolution |
|-------|---------|------------|
| `self` | Skills in the same repo as this agent | Runtime searches the agent's home pack first. |
| `ruby-core-skills` | Shorthand for `igmarin/ruby-core-skills` | Runtime searches the `core` pack. |
| `igmarin/ruby-core-skills` | Full repo slug | Runtime maps slug to pack name via `registry.json`. |
| `igmarin/agnostic-planning-skills` | Full repo slug | Runtime maps slug to pack name via `registry.json`. |

**Shorthand rule:** If `source` does not contain a `/`, it is treated as a pack name from `registry.json`. If it contains a `/`, it is treated as a repo slug and mapped to its pack.

### 2.4 Validation

At agent load time, the runtime:

1. Parses `metadata.dependencies`.
2. For each `source: self` entry, verifies the skills exist in the agent's home pack.
3. For each external source, verifies the skills exist in the resolved pack.
4. If a skill is not found, logs: `WARNING: Agent 'tdd' depends on 'tdd-process' from 'ruby-core-skills', but this skill was not found in the loaded packs.`
5. Warnings are non-fatal — the agent may still function if the skill is optional or will be loaded dynamically.

---

## 3. Body Annotation Convention

### 3.1 Inline References

Within the body of an agent's `SKILL.md`, when referencing a skill from another repo, append `*(from <pack>)*` after the skill name for human readability.

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

### 3.2 Annotation Rules

| Rule | Example |
|------|---------|
| Same-repo skills: no annotation | `**load-context**: Load schema...` |
| Core skills: annotate with `*(from ruby-core-skills)*` | `**tdd-process** *(from ruby-core-skills)*` |
| Planning skills: annotate with `*(from agnostic-planning-skills)*` | `**create-prd** *(from agnostic-planning-skills)*` |
| First mention only: annotate; subsequent mentions optional | Annotate first mention; later references can be bare if context is clear. |

### 3.3 Integration Tables

Many skills include an Integration table naming the next skill to load. When updating framework skills to reference core process skills, update the Integration table:

```markdown
## Integration

| Context | Next Skill |
|---------|-----------|
| After writing tests, before implementation | **tdd-process** *(from ruby-core-skills)* |
| After implementation passes | **code-review** |
| After self-review | **respond-to-review** (if feedback received) |
```

---

## 4. Examples by Agent

### 4.1 Rails `tdd` Agent

```yaml
---
name: tdd
license: MIT
description: >
  Full TDD feature cycle: test → implement → review → PR
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

### 4.2 Rails `review` Agent

```yaml
---
name: review
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

### 4.3 Rails `quality` Agent

```yaml
---
name: quality
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

### 4.4 Hanami `tdd-loop` Agent

```yaml
---
name: tdd-loop
license: MIT
description: >
  Hanami TDD feature cycle: plan → test → implement → review
metadata:
  version: 1.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills:
        - load-context
        - write-request-spec
        - review-code
    - source: ruby-core-skills
      skills:
        - tdd-process
        - test-planning-process
        - write-yard-docs
---
```

### 4.5 Hanami `slice-lifecycle` Agent

```yaml
---
name: slice-lifecycle
license: MIT
description: >
  Slice development: create → test → review
metadata:
  version: 1.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills:
        - create-slice
        - test-slice
        - review-slice-boundaries
    - source: ruby-core-skills
      skills:
        - refactor-process
        - review-process
---
```

---

## 5. Rules for Framework Repo Authors

### 5.1 When to Declare Dependencies

| Scenario | Action |
|----------|--------|
| Agent chains a skill from core | Add to `dependencies` with `source: ruby-core-skills` |
| Skill's Integration table references a core skill | No frontmatter change needed; annotate body with `*(from ruby-core-skills)*` |
| Agent chains only same-repo skills | Omit `dependencies` or use only `source: self` |
| Skill contains process knowledge that should be universal | Consider extracting to `ruby-core-skills` as a process skill |

### 5.2 Agent SKILL.md Update Checklist (Phase 2)

- [ ] Frontmatter includes `metadata.dependencies` with all cross-repo skills
- [ ] Body annotations use `*(from ruby-core-skills)*` for first mention of each core skill
- [ ] Integration tables updated to reference core process skills where applicable
- [ ] Agent workflow diagram (if present) updated to show core skill boundaries

---

## 6. Runtime Dependency Resolution Flow

```
1. User invokes agent: agent-mcp-runtime --pack rails use_agent tdd
2. Runtime loads agent SKILL.md from rails pack
3. Runtime parses metadata.dependencies
4. For each dependency:
   a. Resolve source to a pack (self → rails, ruby-core-skills → core)
   b. Load skill from that pack into context
   c. If skill not found, log WARNING
5. Agent execution begins with all declared skills loaded
6. If agent body references a skill not in dependencies:
   a. Runtime attempts to resolve it on-demand
   b. If found, loads it dynamically
   c. If not found, logs WARNING: "Agent referenced 'unknown-skill' but it was not declared in dependencies and was not found in loaded packs."
```

---

## 7. Backwards Compatibility

Agents in `rails-agent-skills` v5.1.17 do not have `metadata.dependencies`. During Phase 2 migration:

1. Add `metadata.dependencies` to each agent's `SKILL.md` frontmatter.
2. Agents without `dependencies` are still valid — the runtime treats them as "dependencies: []".
3. Dynamic resolution (on-demand skill loading) continues to work for undeclared references.
4. The `dependencies` field is advisory for validation and documentation; it is not a strict gate.

---

## Appendix A — Verification Checklist

- [ ] Every agent that chains core skills has `metadata.dependencies` in frontmatter
- [ ] `source: self` skills exist in the agent's home repo `tile.json`
- [ ] `source: ruby-core-skills` skills exist in `ruby-core-skills` `tile.json`
- [ ] Body annotations use the `*(from ruby-core-skills)*` convention consistently
- [ ] Integration tables in framework skills reference core process skills where appropriate
- [ ] No hard-coded file paths in dependency declarations
- [ ] Shorthand pack names (no `/`) resolve correctly via `registry.json`
