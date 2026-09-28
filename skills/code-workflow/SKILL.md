---
name: code-workflow
type: atomic
description: Use for Ruby test-first changes, behavior-preserving refactors, focused code/security reviews, and review responses when no Rails-specific card is a better fit.
metadata:
  user-invocable: "true"
---

# Ruby Code Workflow

Choose the mode that matches the request; do not run the other modes by default.

## Behavior change

Read project instructions and one relevant neighbor. Add or update a focused test for the behavior, run it, then implement the smallest change and rerun it. Run broader checks when the project or change warrants them.

## Refactor

State the behavior being preserved, inspect existing coverage, make one coherent structural change, and run the focused tests. Add characterization tests only where current behavior is unclear or unprotected.

## Review

Treat the diff as the source of truth. Report actionable defects with file/line, scenario, and consequence. For review feedback, map each comment to a code change, a test, or a concise evidence-based response.

## Security

Trace untrusted input and authorization boundaries. Never reproduce secrets. Escalate only concrete risks such as injection, access bypass, unsafe deserialization, or exposed credentials.

Finish with changed files, checks run, and unresolved failures. Do not require test-first steps for documentation, reviews, or mechanical changes that do not alter behavior.
