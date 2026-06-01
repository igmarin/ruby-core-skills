---
name: generate-tdd-tasks
license: MIT
description: >
  Breaks a feature, PRD, or requirement into TDD implementation tasks with task 0.0 as
  feature branch creation (MUST be first), each task uses TDD quadruplet (RED test→run
  fail→GREEN impl→run pass→REFACTOR), includes mandatory public API docs task, update
  docs task, and code review task, output with `Guidance Used` and `Relevant Files`
  sections saved to `tasks/tasks-[name].md`, auto-detects test command/source dir/test
  dir from project conventions. Ruby-first but language-agnostic. Trigger words: tdd task
  list, tdd tasks, generate tasks, tdd breakdown, implementation tasks, task breakdown,
  feature tasks, quadruplet pattern.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "planning"
  related_skills: [tdd-process, write-yard-docs, review-process, test-planning-process]
  related_tiles: [igmarin/agnostic-planning-skills]
---

# Generate TDD Tasks

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

### Step 4: Validation Gates (HARD-GATE)

Before saving output, every gate below MUST pass:

```text
1. Task 0.0 is the feature branch creation — mandatory, must be first.
2. Every implementation task uses the TDD quadruplet (RED → fail → GREEN → pass → REFACTOR).
3. Public API documentation, update existing documentation, and code review tasks are present — do not omit them.
4. Guidance Used section explains what conventions/guides/skills drove the breakdown.
5. Relevant Files section lists detected source and test directories and key files.
6. Output is saved to tasks/tasks-<feature-name>.md unless user specifies otherwise.
```

If any gate fails, correct the task list before saving.

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
