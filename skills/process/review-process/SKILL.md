---
name: review-process
license: MIT
description: >
  Reviews pull requests and code changesets using structured finding templates with severity levels (Critical/Major/Minor/Nitpick), generates self-review checklists for authors, produces findings reports, and determines re-review criteria. Use when the user requests a code review, asks to review a pull request, or needs a structured code audit with severity-classified findings. Trigger words: code review, review PR, PR review, code audit, structured review, severity levels.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# Review Process

Standardized code review process for Ruby code changesets.

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
- [ ] Tests cover happy paths, boundaries, and error states
- [ ] YARD docs on new/modified public interfaces
- [ ] No hardcoded secrets or environment config
- [ ] Syntax checks and linters pass

### Step 3: Analysis (For Reviewers)
Review for correctness, safety, security, and adherence to domain language and documentation standards.

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

- **Cosmetic Bias:** Focusing on nitpicks while ignoring logical flaws, structural smells, or missing tests
- **Performative Reviews:** LGTM approvals without reading the diff, running tests, or verifying edge cases
- **Vague Feedback:** Comments like "this looks weird" or "fix this" without explanation or clear alternatives

## Integration

| Context | Next Skill |
|---------|-----------|
| Addressing review findings | **respond-to-review** |
| Adding missing tests | **tdd-process** |
| Cleaning up identified smells | **refactor-process** |
