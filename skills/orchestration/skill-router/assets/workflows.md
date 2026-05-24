# Additional Workflows

Extended workflow definitions for specialized scenarios. See SKILL.md for the primary workflows (TDD Feature Loop, Bug fix).

---

## Feature (DDD-first)

skills/ddd/define-domain-language → skills/ddd/review-domain-boundaries → skills/ddd/model-domain → skills/process/test-planning-process → skills/process/tdd-process

Use when: Domain modeling is required before implementation, or the feature involves complex bounded contexts.

---

## Code review + response

skills/process/review-process → skills/code-quality/respond-to-review

Use when: Reviewing code changesets and addressing reviewer feedback.

---

## Refactoring

skills/process/refactor-process → **[GATE: characterization tests pass on current code]** → refactor → verify still pass

Use when: Modifying internal structure of code without changing its external behavior.

---

## Security Audit

skills/process/security-review-process → skills/process/review-process
