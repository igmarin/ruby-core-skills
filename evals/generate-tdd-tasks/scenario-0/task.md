# Generate Tdd Tasks Task

## Problem

A Ruby team needs help with a task in this area:

Breaks a feature, PRD, or requirement into TDD implementation tasks with task 0.0 as feature branch creation (MUST be first), each task uses TDD quadruplet (RED test→run fail→GREEN impl→run pass→REFACTOR), includes mandatory public API docs task, update docs task, and code review task, output with `Guidance Used` and `Relevant Files` sections saved to `tasks/tasks-[name].md`, auto-detects test command/source dir/test dir from project conventions.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
