# skill-router — Routing Examples

Extended routing examples covering common, ambiguous, and edge-case scenarios. Each example shows the user prompt, skill match rationale, and the full workflow chain.

Active responses must put `Next skill: ...` first. When multiple skills may apply, put one concise priority/chain statement immediately after it, before analysis or implementation.

---

## Single-Skill Routes (Clear Intent)

### 1. Triage Bug

> **User:** "Triage a NoMethodError observed in Orders::Creator when item_id is nil."
>
> **Match:** Concrete bug with reproduction path.
>
> **Chain:** `triage-bug` → `tdd-process`
>
> **Next skill: skills/testing/triage-bug**

### 2. Create Service Object

> **User:** "I need a service class to sync users from our external CRM."
>
> **Match:** Service extraction + external API integration. Two skills apply.
>
> **Chain:** `integrate-api-client` (API client layers) → `create-service-object` (sync coordination) → `tdd-process` (spec/test implementation)
>
> **Next skill: skills/patterns/integrate-api-client**

### 3. Documenting Code

> **User:** "Document this payment module public interface using YARD."
>
> **Match:** Inline documentation.
>
> **Chain:** `write-yard-docs`
>
> **Next skill: skills/docs/write-yard-docs**

---

## Multi-Concern Routes (Workflow Chains)

### 4. Full Feature from Scratch

> **User:** "I want to add a payment feature but I'm not sure where to start."
>
> **Match:** Scope unclear, no existing design, vague starting point.
>
> **Chain:** `define-domain-language` → `model-domain` → `test-planning-process` → `tdd-process`
>
> **Next skill: skills/ddd/define-domain-language**

### 5. Multi-Concern Review

> **User:** "Review this pull request. It changes domain models, adds parser rules, and changes authentication helpers."
>
> **Match:** Multi-concern changeset. Decompose before reviewing.
>
> **Chain:** `security-review-process` (authentication/input handling) → `review-process` (general code review)
>
> **Next skill: skills/process/security-review-process**
>
> **Priority: security-review-process > review-process; Chain: security-review-process then review-process.**

### 6. DDD-First Feature

> **User:** "We're building an invoicing module and need to get the domain language right before coding."
>
> **Match:** Domain modeling before implementation.
>
> **Chain:** `define-domain-language` → `review-domain-boundaries` → `model-domain` → `test-planning-process` → `tdd-process`
>
> **Next skill: skills/ddd/define-domain-language**

---

## Ambiguous & Low-Context Routes

### 7. Vague Request — No Clear Skill

> **User:** "Help me improve this Ruby codebase."
>
> **Match:** No specific concern. Start with domain discovery to identify what needs work.
>
> **Chain:** `define-domain-language` → (assess findings) → route to appropriate skill
>
> **Next skill: skills/ddd/define-domain-language**

### 8. Ambiguous — Which Test Skill?

> **User:** "I need to add tests for the billing module."
>
> **Match:** "Add tests" is ambiguous. If the user doesn't know *what* to test first → `test-planning-process`. If they know what but not *how* → `tdd-process`.
>
> **Disambiguation:** Ask: "Do you know which behavior to test first, or should we figure that out?" If unclear, default to `test-planning-process`.
>
> **Next skill: skills/process/test-planning-process**

---

## Edge Cases

### 9. Refactoring with No Tests

> **User:** "I want to refactor this class but there are no tests."
>
> **Match:** Refactoring requires characterization tests first. TDD gate applies.
>
> **Chain:** `test-planning-process` → `tdd-process` (write characterization tests) → **[GATE: tests pass on current code]** → `refactor-process`
>
> **Next skill: skills/process/test-planning-process**
