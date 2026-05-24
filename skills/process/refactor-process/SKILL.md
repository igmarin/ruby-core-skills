---
name: refactor-process
license: MIT
description: >
  Enforces a disciplined refactoring process. Requires passing characterization
  tests, small incremental changes, and verification after every single step.
  Trigger words: refactor, clean up code, rewrite class, structure changes, simplify.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# Refactor Process

A disciplined framework for restructuring existing Ruby code safely without altering its external behavior.

## Quick Reference

| Aspect | Rule |
|--------|------|
| **Pre-requisite** | Characterization tests must exist and be Green |
| **Step Size** | One transformation at a time (e.g. rename variable, extract method) |
| **Verification** | Run tests after *every* single step |
| **Rollback** | If a step turns tests Red, undo it immediately. Do not try to debug in a broken state. |

## HARD-GATE

```text
REFACTORING GATES:
1. DO NOT start refactoring unless there is test coverage (characterization tests) that passes (turns Green) on the CURRENT code.
2. DO NOT change external behavior during refactoring (no new features, no bug fixes, no changed return values).
3. If tests turn Red during refactoring, you MUST roll back the change immediately and find a smaller/safer transformation.
4. Run the test suite after every single code change.
```

## Process Steps

### Step 1: Establish the Baseline
- Run the existing tests for the class or module.
- If coverage is missing or weak, write **characterization tests** (tests that capture the current behavior, including edge cases and errors).
- Verify all tests are Green.

### Step 2: Plan the Steps
- Identify the goal (e.g., extract a complex method into its own class, simplify a conditional block).
- Break the goal down into a sequence of atomic refactoring operations:
  - Rename variable / method
  - Extract variable / method
  - Inline variable / method
  - Move method / field
  - Replace conditional with polymorphism

### Step 3: Execute and Verify Loop
For each planned step:
1. Make the singular, atomic code modification.
2. Run the tests.
3. If Green, save/commit the step and proceed.
4. If Red, discard the change (e.g., via git checkout or undo), analyze why it broke, and try a smaller step.

---

## Checkpoint Pattern

Pause and align with the user:
1. **Baseline Checkpoint:** Show the characterization tests and current implementation before making any edits.
2. **Refactoring Proposal:** Outline the planned steps of transformations.
3. **Completion Checkpoint:** Present the final refactored code and the test suite validation report.

---

## Example Refactoring Loop (Extract Method)

**Baseline (Green):**
```ruby
class ReportGenerator
  def generate(data)
    # Formats raw data to report
    formatted = data.map { |row| "#{row[:id]}: #{row[:name].strip.capitalize}" }
    
    # Renders report
    "=== Report ===\n" + formatted.join("\n") + "\n=============="
  end
end
```

**Step 1: Extract Formatter Logic (Atomic Edit):**
```ruby
class ReportGenerator
  def generate(data)
    formatted = format_rows(data)
    "=== Report ===\n" + formatted.join("\n") + "\n=============="
  end

  private

  def format_rows(data)
    data.map { |row| "#{row[:id]}: #{row[:name].strip.capitalize}" }
  end
end
```
*Action:* Run tests immediately. Confirm Green.

**Step 2: Add YARD Docs and final clean up (Atomic Edit):**
Add YARD docs to the new private method. Run tests. Confirm Green.

---

## Anti-Patterns

- **Refactoring in a Broken State:** Trying to clean up code while tests are Red or when features are only partially implemented.
- **The "Giant Leap" Refactor:** Making multiple non-trivial changes at once (e.g. renaming three classes and changing an API client layer) and then trying to fix all compiling/test failures. Always take small steps.
- **Behavior Creep:** Sneaking a small bug fix or performance optimization into a refactoring commit. Keep refactoring and behavior changes completely separate.

## Integration

| Context | Next Skill |
|---------|-----------|
| Establishing baseline coverage | **test-planning-process** → **tdd-process** |
| Documenting newly extracted APIs | **write-yard-docs** |
| Post-refactoring review | **review-process** |

## What This Skill Does NOT Cover
This skill does not cover framework-specific refactoring targets (like moving Rails controller filters to middleware, or ROM schema migration steps).
