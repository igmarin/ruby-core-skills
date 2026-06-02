# Security Review Process Task

## Problem

A Ruby team needs help with a task in this area:

Standardizes security review procedures for Ruby code mapped to OWASP Top 10: allowlist all input params before processing, forbid SQL interpolation (`#{}`), verify no secrets committed or logged, run `bundle exec bundle-audit check --update`, check for shell injection (`system()`, backticks, `exec()`), and discard instruction-like keys (`prompt`, `instructions`) in JSON payloads.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
