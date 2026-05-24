---
name: test-planning-process
license: MIT
description: >
  Defines a test-planning decision framework. Helps select test boundaries,
  identify test cases (happy path, edge case, error), and pick the first failing test.
  Trigger words: test plan, planning tests, what tests to write, test coverage, test scope.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# Test Planning Process

A standardized, framework-agnostic process for planning what test cases to write and determining test boundaries before coding.

## Quick Reference

| Dimension | Rule |
|-----------|------|
| **Test Boundary** | Test at the highest boundary that directly expresses the feature's business goal (e.g. integration/request vs unit) |
| **Coverage Goal** | Cover all primary paths, all input boundary values, and all expected error flows |
| **First Failing Test** | Select the single simplest assertion that will fail on the current code and prove the feature is missing |
| **Isolation** | Isolate tests from external networks, dates, and shared database states |

## HARD-GATE

```text
TEST PLANNING GATES:
1. DO NOT write test cases without defining a test plan first.
2. ALWAYS start testing at the most relevant boundary (don't write 10 unit tests for a feature that needs a request test, and vice versa).
3. The first failing test MUST be identified explicitly in the plan before writing it.
4. All test data must be synthetic; never use real production values or API payloads in test plans.
```

## Process Steps

### Step 1: Determine the Test Boundary
Identify where the behavior is observed:
- **Request / API Boundary:** Use when verifying HTTP statuses, headers, query parsing, or JSON payload structures.
- **Service / Business Boundary:** Use when validating domain invariants, complex calculations, or coordination between objects.
- **Unit Boundary:** Use when verifying low-level calculations, state changes on a single object, or formatting logic.

### Step 2: List the Test Cases
For the selected boundary, map out the test matrix:
1. **Happy Paths:** Standard expected execution flows.
2. **Boundary Values:** Zero, nil, empty strings, maximum lengths, negative values.
3. **Error Paths:** Invalid inputs, database failures, external service timeouts, auth failures.

### Step 3: Select the First Failing Test
- Choose the single simplest test case from the matrix that is expected to fail on the current code.
- This serves as the initial "Red" state to kick off the TDD loop.

### Step 4: Plan Test Isolation
- Identify any external dependencies (network APIs, system clocks, file systems).
- Plan mocks, stubs, or test doubles to isolate the tests and prevent flaky failures.

---

## Checkpoint Pattern

Align with the user:
1. **Test Plan Proposal:** Present the target boundary, the list of happy/edge/error cases, and specify which test will be the first failing test.
2. **Handoff:** Present the skeleton code for the first failing test before writing any implementation.

---

## Test Planning Grid Example (User Registration)

### 1. Test Boundary: Request (Integration) Level

### 2. Test Case Matrix:

| Scenario | Input Category | Expected Result |
|----------|----------------|-----------------|
| Valid registration | Happy Path | `201 Created` with User ID |
| Duplicate email | Edge Case | `422 Unprocessable` with message |
| Nil/Empty email | Boundary Case | `422 Unprocessable` with validation error |
| DB Timeout | Error Path | `503 Service Unavailable` |

### 3. First Failing Test:
`POST /register` with valid registration returns `201 Created`. (Fails currently with `404 Not Found` or `NoMethodError`).

---

## Anti-Patterns

- **Coverage Blindness:** Writing tests only for the happy path and ignoring error/edge cases.
- **Low-Value Testing:** Writing hundreds of low-level unit tests for simple getter/setter methods while having zero integration tests verifying that the components actually work together.
- **Shared State Leaks:** Allowing tests to write to a shared database or system file without cleaning up, causing subsequent tests to fail randomly.

## Integration

| Context | Next Skill |
|---------|-----------|
| Writing the failing test | **tdd-process** |
| General design modeling | **model-domain** |
