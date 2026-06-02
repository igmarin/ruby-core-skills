# Tdd Process Task

## Problem

A Ruby team needs help with a task in this area:

Enforces Red-Green-Refactor with hard gates: Red phase writes failing test that MUST fail on assertion (not syntax/config) and presents test+failure before proceeding, runs tests on the specific file (not full suite) after each phase, Green phase writes minimal code to pass and stops there, Refactor phase runs test after each micro-change and MUST stay Green throughout.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
