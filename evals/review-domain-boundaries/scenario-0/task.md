# Review Domain Boundaries Task

## Problem

A Ruby team needs help with a task in this area:

Use when reviewing a Ruby app for DDD (domain-driven design) boundaries, module boundaries, service boundaries, or code organization: detects bounded contexts, language leakage, cross-context orchestration, and unclear ownership — uses `rg` to find cross-context references and leaked terms, identifies misplaced domain models and documents ownership direction (which context owns invariants, transitions, and side effects), proposes the smallest credible boundary improvement before large reorganizations, outputs findings first then open questions then recommended next skills, and loads boundary-leakage examples only when their content is needed.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
