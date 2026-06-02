# Review Process Task

## Problem

A Ruby team needs help with a task in this area:

Reviews PRs using structured findings with severity levels (Critical/Major/Minor/Nitpick), verifies changeset includes tests for new/modified logic, reviews for correctness + safety + security + domain language adherence, checks for scope creep and authorization gaps (missing checks are Critical), presents structured table of findings by severity, generates self-review checklists for authors, produces findings reports, determines re-review criteria — and performs re-review verification by reviewing the diff against each finding.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
