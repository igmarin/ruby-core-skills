---
name: generate-tdd-tasks
license: MIT
description: >
  Breaks a feature, PRD, or requirement into TDD implementation tasks using the
  TDD quadruplet pattern: RED (write failing test) → run fail → GREEN (implement) →
  run pass → REFACTOR. Always creates feature branch as task 0.0, then groups
  implementation tasks by behavior. Every task list includes public API docs,
  update documentation, and code review tasks. Output includes Guidance Used and
  Relevant Files sections. Auto-detects test commands, source directories, and
  test directories from project conventions. Ruby-first but language-agnostic.
  Trigger words: tdd task list, tdd tasks, generate tasks, tdd breakdown,
  implementation tasks, task breakdown, feature tasks, quadruplet pattern.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "planning"
  related_skills: [tdd-process, write-yard-docs, review-process, test-planning-process]
  related_tiles: [igmarin/agnostic-planning-skills]
---

# Generate TDD Tasks

## Quick Reference

| Rule | Detail |
|------|--------|
| **Task 0.0** | Always create feature branch first: `git checkout -b feature/<name>` |
| **TDD quadruplet** | Each implementation task has 5 sub-steps: RED test → Run fail → GREEN impl → Run pass → REFACTOR |
| **Auto-detect** | Test command, source directory (`lib/` or `src/`), test directory (`spec/` or `test/`) |
| **Required tasks** | Public API docs, update existing docs, code review — always included |
| **Output path** | `tasks/tasks-<feature-name>.md` |
| **Required sections** | `Guidance Used` and `Relevant Files` at the top |
| **Language** | English unless explicitly requested otherwise |

## HARD-GATE

```text
TASK GENERATION GATES:
1. Feature branch (task 0.0) MUST be the first task in every task list.
2. Every implementation task MUST use the TDD quadruplet pattern (RED → fail → GREEN → pass → REFACTOR).
3. Public API documentation, update existing documentation, and code review tasks are MANDATORY — do not omit them.
4. Guidance Used section MUST explain what conventions/guides/skills drove the breakdown.
5. Relevant Files section MUST list detected source and test directories and key files.
6. Output MUST be saved to tasks/tasks-<feature-name>.md unless user specifies otherwise.
```

## Core Process

### Step 1: Project Detection

Detect and list the project's conventions before generating tasks:

1. **Test command** — Check config files. Ruby: `bundle exec rspec` if `Gemfile` has `rspec`. Python: `pytest`. JS/TS: `npm test` / `yarn test`. Rust: `cargo test`. Go: `go test ./...`.
2. **Source directory** — `lib/` (Ruby), `src/` (most other languages).
3. **Test directory** — `spec/` (RSpec), `test/` (Minitest/pytest/unittest/Go standard).
4. **Doc tool** — YARD (Ruby), JSDoc (JS/TS), rustdoc (Rust), pydoc (Python).
5. **Language/framework** — Detect from `Gemfile`, `Cargo.toml`, `package.json`, `go.mod`, `pyproject.toml`.

### Step 2: Requirements Analysis

Break down the feature/PRD into implementation tasks:

1. **Identify user-visible behaviors** — capabilities, endpoints, data flows.
2. **Apply first-slice heuristics**:
   - Web app / API: Start with request/integration test.
   - Service / domain logic: Start with service or unit test.
   - Background job: Start with worker test.
   - External integration: Start with client layer test.
   - Library / SDK: Start with public API test.
3. **Group related behaviors** into parent tasks with TDD quadruplets.

### Step 3: Generate Task List

Create `tasks/tasks-<feature-name>.md` with the required structure below.

### Step 4: Validation Checkpoint

1. Is task 0.0 the feature branch creation? (yes — mandatory)
2. Does every impl task use the TDD quadruplet pattern? (yes — mandatory)
3. Are public API docs, update docs, and code review tasks included? (yes — mandatory)
4. Do Guidance Used and Relevant Files sections exist? (yes — mandatory)
5. Is the output path correct? (must be `tasks/tasks-<feature-name>.md`)

## Task List Template

```markdown
# Task List: <Feature Name>

Based on: <prd or requirement source>

## Guidance Used

- <Skill or convention that guided this breakdown — e.g. tdd-process, test-planning-process, project conventions>
- <Specific decisions: why first slice chosen, why certain boundary selected>

## Relevant Files

- Source directory: `<detected source dir>/`
- Test directory: `<detected test dir>/`
- `<path/to/file.ext>` — <why it's relevant>
- `<path/to/test.ext>` — <test coverage>

---

## Tasks

- [ ] **0.0 Create feature branch**
  `git checkout -b feature/<feature-name>`

- [ ] **1.0 <Behavior Description> (TDD Quadruplet)**
  - [ ] 1.1 Write failing test for `<behavior>`
        `<test-dir>/path/to/test.ext`
  - [ ] 1.2 Run test — verify failure
        `<test-command>` → expected failure
  - [ ] 1.3 Implement minimal code to pass
        `<source-dir>/path/to/impl.ext`
  - [ ] 1.4 Run test — verify success
        `<test-command>` → green
  - [ ] 1.5 REFACTOR: Clean up implementation

- [ ] **2.0 <Next Behavior> (TDD Quadruplet)**
  - [ ] 2.1 ... (same pattern as 1.1-1.5)

- [ ] **3.0 <Next Behavior> (TDD Quadruplet)**
  - [ ] 3.1 ...

- [ ] **N.0 Public API Documentation**
  - [ ] N.1 Add YARD/JSDoc/rustdoc/pydoc comments to all new public methods
        `<source-dir>/path/to/file.ext`

- [ ] **N+1.0 Update Existing Documentation**
  - [ ] N+1.1 Update README or relevant docs for any changed behavior

- [ ] **N+2.0 Code Review**
  - [ ] N+2.1 Self-review diff before creating PR
  - [ ] N+2.2 Run full test suite — all green
```

## Integration

| Context | Next Skill |
|---------|-----------|
| Executing the TDD loop | **tdd-process** |
| Choosing the first failing test | **test-planning-process** |
| Documenting public APIs | **write-yard-docs** |
| Reviewing the final changeset | **review-process** |
| PRD or requirements source | **create-prd** (agnostic-planning-skills) |
| Refining individual tickets | **plan-tickets** (agnostic-planning-skills) |
