---
name: refactor-process
license: MIT
description: >
  Enforces a disciplined refactoring process for Ruby code: ONE atomic transformation
  at a time, characterization tests MUST exist and be Green BEFORE any edit, run tests
  after EVERY single step, rollback immediately on Red (no debugging in broken state),
  no behavior changes mixed with refactoring. Covers extract methods, rename symbols,
  split classes, inline variables, remove duplication. Use when: refactor, clean up code,
  rewrite class, structure changes, simplify.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# Refactor Process

## Quick Reference

| Aspect | Rule |
|--------|------|
| **Pre-requisite** | Characterization tests must exist and be Green before any edits |
| **Step Size** | One atomic transformation at a time (rename variable, extract method, etc.) |
| **Verification** | Run tests after *every* single step |
| **No Behavior Changes** | No new features, bug fixes, or changed return values during refactoring |
| **Rollback** | If tests turn Red, undo immediately — do not debug in a broken state |

## Process Steps

### Step 1: Establish the Baseline
- Run the existing tests for the class or module.
- If coverage is missing or weak, write **characterization tests** (tests that capture the current behavior, including edge cases and errors).
- Verify all tests are Green before proceeding.

### Step 2: Plan the Steps
- Identify the goal (e.g., extract a complex method into its own class, simplify a conditional block).
- Break the goal into a sequence of atomic refactoring operations (rename, extract, inline, move, replace conditional, etc.).

### Step 3: Execute and Verify Loop
For each planned step:
1. Make the singular, atomic code modification.
2. Run the tests.
3. If Green, save/commit the step and proceed.
4. If Red, discard the change (e.g., via `git checkout` or undo), analyze the root cause, and try a smaller step.

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

---

## Anti-Patterns

- **Behavior Creep:** Keep refactoring and behavior changes (bug fixes, optimizations) in completely separate commits.
- **The "Giant Leap" Refactor:** Multiple non-trivial changes at once make failures hard to diagnose; always take the smallest possible atomic step.

## Integration

| Context | Next Skill |
|---------|----------|
| Establishing baseline coverage | [test-planning-process](../test-planning-process/SKILL.md) → [tdd-process](../tdd-process/SKILL.md) |
| Documenting newly extracted APIs | [write-yard-docs](../../docs/write-yard-docs/SKILL.md) |
| Post-refactoring review | [review-process](../review-process/SKILL.md) |
