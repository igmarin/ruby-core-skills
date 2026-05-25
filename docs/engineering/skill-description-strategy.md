# Skill Description Strategy

*How to optimize `description` metadata for baseline eval scores.*

## The Bottleneck

The Tessl eval task prompt includes only the **first sentence** of the skill's `description` metadata (via `sentence_from_description` which splits on `/(?<=[.!?])\s+/`).

Everything after the first period+space is invisible to the agent in baseline mode. The first sentence is the only signal the agent receives about the skill's conventions.

## Rules

### Rule 1: Pack all critical rules into the first sentence

Use one long sentence with commas, colons, and em dashes — no periods until the very end:

```
description: >
  Use when creating service classes with `self.call` entry point,
  `{success:, response:}` response contract, spec at `spec/services/...`,
  `UPPER_SNAKE_CASE` error constants, mandatory module README, and test BEFORE
  implementation. Covers 4 core patterns...
```

Everything up to the first `. ` becomes the task prompt.

### Rule 2: No `...` followed by whitespace

Backtick expressions like `{ ... } }` contain `...` followed by a space. The regex `(?<=[.!?])\s+` splits at the third `.` + space, truncating the first sentence.

**Bad:** `{ success: true/false, response: { ... } }` → splits after `...`

**Good:** `{success: true/false, response: {...}}` → no space after `...`

Same rule applies to `message: "..."}` → no space after `...`.

### Rule 3: Use `—` (em dash) or `,` instead of second period

If you need a pause, use an em dash or comma instead of a period:

**Bad:**
```
Create service classes with .call pattern. Spec at spec/services/.
```

**Good:**
```
Create service classes with .call pattern, spec at spec/services/
```

### Rule 4: Put trigger words after the first sentence

Trigger words are for skill selection, not for the task prompt. Place them after the first period where they're available for selection but don't consume task-prompt space.

## Measurement

Before applying this strategy (v1.0.0): **54% baseline avg**
After applying (v1.1.0): **85% baseline avg**

Largest single-skill improvements:
- refactor-process: 33% → 100%
- generate-tdd-tasks: 20% → 97%
- skill-router: 50% → 98%
- integrate-api-client: 37% → 93%
- create-service-object: 19% → 85%
