---
name: model-domain
license: MIT
description: >
  Use when modeling DDD concepts in Ruby: start from domain invariants and ownership before
  choosing patterns, prefer default Ruby classes over extra abstractions, entity when identity
  matters, value object when equality by value is correct, aggregate root guards state transitions
  as single entry point, domain service for behavior spanning multiple entities, application
  service orchestrates one use case — only add repository when real persistence boundary exists.
  Covers mapping of entities, aggregates, value objects, domain services, application services,
  repositories, and domain events without over-engineering.
metadata:
  version: 1.0.0
  user-invocable: "true"
  origin: "Extracted from igmarin/rails-agent-skills v5.1.17"
---
# Model Domain

## Quick Reference

| DDD concept | Ruby default | Avoid by default | Typical home |
|-------------|---------------------|------------------|--------------|
| Entity | Plain class when persisted identity matters | Extra wrapper object with no added meaning | `models/` or project namespace |
| Value object | PORO — immutable, equality by value | Shoving logic into helpers or primitives | `models/` or near the domain |
| Aggregate root | The class that guards invariants and is the single entry point | Splitting invariants across multiple models/classes | `models/` or project namespace |
| Domain service | PORO for behavior spanning multiple entities | Arbitrary model chosen just to hold code | `services/` |
| Application service | Orchestrator for one use case | Fat controllers, callback chains, or leaking rules | `services/` |
| Repository | Only when a real persistence boundary exists beyond simple data access | Repositories for every query | `repositories/` |
| Domain event | Explicit object when multiple downstream consumers justify it | Callback-driven hidden side effects | `events/` or project namespace |

## HARD-GATE

```text
DO NOT introduce repositories, aggregates, or domain events just to sound "DDD".
DO NOT fight simple Ruby defaults when a normal class or service expresses the domain clearly.
ALWAYS start from domain invariants, ownership, and lifecycle before choosing a pattern.
MODELING OUTPUT IS NOT IMPLEMENTATION: do not include Ruby implementation code,
database migrations, or service bodies unless the user explicitly asks to move from
modeling into build work.
```

## Core Process

**Core principle:** Model real domain pressure, not textbook DDD vocabulary.

### Modeling Order

1. **List domain concepts:** Entities, values, policies, workflows, and events from the ubiquitous language.
2. **Identify invariants:** Ask: what must always be true after any state change? What breaks if two callers mutate the same state simultaneously? Decide which object or boundary must keep each rule true.
3. **Choose the aggregate entry point:** Name the object that guards state transitions and consistency. Ask: is there exactly one place a caller must go to change this state?
4. **Place behavior:** Keep behavior on the entity/aggregate when cohesive; extract a domain service only when behavior spans multiple concepts cleanly. Ask: does moving this out clarify ownership, or just spread it?
5. **Pick project homes:** Choose the simplest directory location that matches the boundary and repo conventions.
6. **Verify with tests:** Hand off to `test-planning-process` and `tdd-process` before implementation.

### Common Mistakes

| Mistake | Reality |
|---------|----------|
| Turning every concept into a service | Many behaviors belong naturally on entities or value objects |
| Treating aggregates as folder names only | Aggregates exist to protect invariants, not to look architectural |
| Adding domain events for one local callback | Events justify their cost only when multiple downstream consumers exist |
| Pattern choice justified only with "DDD says so" | The reason must be an invariant, ownership boundary, or clear coordination need |
| Same invariant enforced from multiple unrelated entry points | Single aggregate root guards state transitions — one entry point per invariant |
| New abstractions that increase indirection without clarifying ownership | If the boundary is unclear after modeling, the abstraction is premature |

## Extended Resources

- [assets/examples.md](assets/examples.md) — Worked examples for multi-aggregate domains using pure Ruby.
- [assets/modeling_template.md](assets/modeling_template.md) — Blank output template for a single domain concept.

> [!NOTE]
> For Rails-specific DDD mapping (e.g. mapping ActiveRecord associations and migrations), see `model-domain` in `rails-agent-skills` when using the Rails pack.

## Output Style

For each domain concept, return a compact entry covering:

1. **Domain concept** — name from the ubiquitous language
2. **Recommended modeling choice** — entity, value object, service, etc.
3. **Suggested file path** — file location (e.g., `lib/` or `services/`)
4. **Invariant or ownership reason** — the rule that must stay true and the exact object responsible for enforcing it
5. **Patterns to avoid** — what not to reach for
6. **Test handoff** — first behavior to verify, likely test/spec type, and that implementation is deferred until `test-planning-process` selects the test and `tdd-process` writes it
7. **Next skill to chain** — e.g. `test-planning-process`

### Inline Example — Order aggregate

**Domain concept:** Order | **Modeling choice:** Aggregate root | **Suggested file path:** `lib/orders/order.rb`

**Invariant:** An Order must never transition from `cancelled` back to `active`, and its total must always reflect current line items. `Order` is the single entry point; no external caller may mutate line items or status directly.

**Avoid:** Do not extract an `OrderService` just to hold `place` and `cancel` — that behavior belongs on the aggregate. Do not introduce `OrderRepository` unless a non-standard database persistence backend is required.

**Test handoff:** First behavior — `Order#cancel` raises when already cancelled. Spec type: unit model spec (`spec/orders/order_spec.rb`). Implementation deferred until `test-planning-process` selects this spec and `tdd-process` writes it.

**Next:** `test-planning-process` to select the first failing spec for `Order#cancel`.

## Integration

| Skill | When to chain |
|-------|---------------|
| **define-domain-language** | When the terms are not clear enough to model yet |
| **review-domain-boundaries** | When the modeling problem is really a context boundary problem |
| **test-planning-process** | When the next step is choosing the best first failing spec |
