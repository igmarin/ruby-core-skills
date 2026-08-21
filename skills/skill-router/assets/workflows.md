# Additional Workflows

Extended workflow definitions for specialized scenarios. See SKILL.md for the primary workflows (TDD Feature Loop, Bug fix).

---

## Feature (DDD-first)

skills/define-domain-language → skills/review-domain-boundaries → skills/model-domain → skills/test-planning-process → skills/tdd-process

Use when: Domain modeling is required before implementation, or the feature involves complex bounded contexts.

---

## Code review + response

skills/review-process → skills/respond-to-review

Use when: Reviewing code changesets and addressing reviewer feedback.

---

## Refactoring

skills/refactor-process → **[GATE: characterization tests pass on current code]** → refactor → verify still pass

Use when: Modifying internal structure of code without changing its external behavior.

---

## Security Audit

skills/security-review-process → skills/review-process
