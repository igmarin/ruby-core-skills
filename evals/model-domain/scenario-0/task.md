# Model Domain Task

## Problem

A Ruby team needs help with a task in this area:

Use when modeling DDD concepts in Ruby: start from domain invariants and ownership before choosing patterns (document each concept with its invariant example, e.g., cancelled→active state transition guard, and patterns to avoid), prefer default Ruby classes over extra abstractions, entity when identity matters, value object when equality by value is correct, aggregate root guards state transitions as single entry point, domain service for behavior spanning multiple entities, application service orchestrates one use case — hand off to test-planning-process and tdd-process before implementation, and only add repository when real persistence boundary exists.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
