---
name: review-process
license: MIT
description: >
  Standardizes the code review process. Defines severity levels, structured
  finding templates, self-review checklists, and re-review criteria.
  Trigger words: code review, review PR, PR review, code audit, check code.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# Review Process

A standardized, objective process for reviewing Ruby code changesets.

## Quick Reference

| Severity | Definition | Target Action |
|----------|------------|---------------|
| **Critical** | Security issue, data corruption risk, crash/unhandled exception | Must resolve; blocks merge |
| **Major** | Logical flaw, structural issue, design smell, missing tests | High priority to fix before merge |
| **Minor** | Inefficient query, duplicate code, suboptimal naming, missing YARD | Optional/nice-to-have in this changeset |
| **Nitpick** | Formatting, style guides, purely cosmetic | Acknowledge; do not block merge |

## HARD-GATE

```text
REVIEW GATES:
1. Every review must classify findings using the standard severity levels (Critical, Major, Minor, Nitpick).
2. Any Critical finding automatically blocks the review; a re-review is MANDATORY once addressed.
3. The reviewer must verify that the changeset includes tests for any new or modified logic.
4. DO NOT merge changesets that contain unresolved Critical issues.
```

## Process Steps

### Step 1: Context Gathering
- Read the issue, PR description, or user request to understand the business intent.
- Identify the changed files and the overall scope.

### Step 2: Self-Review Checklists (For Authors)
Before requesting a review, verify:
- [ ] Tests are written, covering happy paths, boundaries, and error states.
- [ ] YARD inline documentation exists for all new/modified public interfaces.
- [ ] Code is free of hardcoded secrets or environment configuration.
- [ ] Standard syntax checks and linters pass cleanly.

### Step 3: Analysis (For Reviewers)
Review the changeset systematically:
1. **Correctness:** Does the code solve the problem? Are edge cases handled?
2. **Safety:** Are exceptions handled properly? Is there any risk of resource leaks, thread safety issues, or data corruption?
3. **Security:** Is input data validated? Are secrets hidden?
4. **Readability & Standards:** Does the code follow ubiquitous domain language? Is it documented?

### Step 4: Write Findings
For each issue identified, format it as a structured finding:
- **Location:** File path and line numbers
- **Severity:** Critical / Major / Minor / Nitpick
- **Description:** What is the technical issue and why is it risky?
- **Suggestion:** Concrete code block or action to fix it.

---

## Checkpoint Pattern

Align with the author or reviewer:
1. **Review Findings Report:** Present the structured table of findings categorized by severity.
2. **Re-Review Verification:** Once fixes are made, review the diff specifically addressing the findings and state the new status.

---

## Structured Finding Example

**Location:** `lib/orders/creator.rb:L15-L25`
**Severity:** Critical
**Description:** Unhandled `ProductNotFoundError` when ordering a product that doesn't exist. This will cause a 500 error in the application controller layer.
**Suggestion:**
```ruby
def call
  # ...
rescue ProductNotFoundError => e
  logger.error("Failed to create order: #{e.message}")
  { success: false, response: { error: { message: "Product not found" } } }
end
```

---

## Anti-Patterns

- **Cosmetic Bias:** Focusing entirely on nitpicks (indentation, style) while ignoring major logical flaws, structural smells, or missing tests.
- **Performative Reviews:** LGTM (Looks Good To Me) approvals without actually reading the diff, running the tests, or verifying edge cases.
- **Vague Feedback:** Writing comments like "this looks weird" or "fix this" without explaining why it's a problem or suggesting a clear alternative.

## Integration

| Context | Next Skill |
|---------|-----------|
| Addressing review findings | **respond-to-review** |
| Adding missing tests | **tdd-process** |
| Cleaning up identified smells | **refactor-process** |
