# Implement Calculator Pattern Task

## Problem

A Ruby team needs help with a task in this area:

Use when building variant-based calculators with SERVICE_MAP routing via `Factory.for(entity)` (ONLY permitted entry point — direct instantiation FORBIDDEN), BaseService defines `calculate`→`compute_result` if `should_calculate?`, NullService has `should_calculate?`=false+`compute_result`=nil, Concrete services override both methods and MUST call `super` in `should_calculate?` — and each component is tested in order (write spec → run → verify Red → implement → run → verify Green before next component, without collapsing NullService and concrete into one step).

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
