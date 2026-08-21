# Skill Description Strategy

*Optimizing `description` metadata so agents and skill catalogs select the right skill.*

## Why the first sentence matters

Agent skill routers, skills.sh catalogs, and many clients surface only a short summary of each skill — often just the **first sentence** of the YAML `description` frontmatter. Everything after the first `. ` (or `!` / `?` + space) is secondary until the agent loads the full `SKILL.md`.

The first sentence is the primary signal for when to use the skill and which hard rules apply. Pack critical conventions there.

## Diagnosis

For any skill:

```bash
# Inspect the description frontmatter
head -20 skills/<skill-name>/SKILL.md

# Measure description length (see Rule 6)
ruby -ryaml -e '
md = File.read("skills/<category>/<skill>/SKILL.md")
_, yaml, _ = md.split(/^---\s*$/, 3)
puts YAML.safe_load(yaml)["description"].length
'
```

If the first sentence is generic (“helps with services”) rather than rule-dense, routing and baseline behavior will be weak.

## Rules

### Rule 1: Pack all critical rules into the first sentence

Use one long sentence with commas, colons, and em dashes — no periods until the critical content ends:

```yaml
description: >
  Use when creating service classes with `self.call` entry point,
  `{success:, response:}` response contract, spec at `spec/services/...`,
  `UPPER_SNAKE_CASE` error constants, mandatory module README, and test BEFORE
  implementation. Covers 4 core patterns...
```

Everything up to the first `. ` is the primary router/catalog signal. Everything after is secondary context.

### Rule 2: Avoid `...` followed by whitespace

Backtick expressions like `{ ... } }` contain `...` followed by a space. Sentence splitters that use `(?<=[.!?])\s+` can truncate mid-expression.

**Bad:** `{ success: true/false, response: { ... } }` → splits after `...`

**Good:** `{success: true/false, response: {...}}` → no space after `...`

`"..."` is fine (third dot followed by `"` not space), but `"..." }` can trigger a split.

### Rule 3: Use `—` (em dash) or `,` instead of periods for pauses

A period ends the first sentence. Use alternatives:

**Bad:**
```
Create service classes with .call pattern. Spec at spec/services/.
```

**Good:**
```
Create service classes with .call pattern, spec at spec/services/
```

### Rule 4: Put trigger words after the first sentence

Trigger words help skill selection in some clients but should not consume first-sentence space:

```
description: >
  Use when creating service classes with .call pattern, spec at
  spec/services/... MUST write test BEFORE implementation.
  Trigger words: service object, .call pattern, services.
```

### Rule 5: Watch for `?` in method names

Splitters often cut on `?` followed by whitespace. `should_calculate?` is fine; `should_calculate? ` with a trailing space may split. Avoid trailing spaces after question marks in the first sentence.

### Rule 6: Stay under the 1024-character limit

Prefer descriptions under **1024 characters** (including YAML `>` folding whitespace). Backtick-heavy sentences burn through this quickly:

```yaml
# Bad — wastes chars on verbose connectors
Auth has `self.default`, `DEFAULT_TIMEOUT`, and cached `#token`.

# Good — uses `+` and compact phrasing
Auth has `self.default` + `DEFAULT_TIMEOUT` + cached `#token`.
```

If over 1024, trim backticks, shorten connectors, or move less-critical rules after the first period.

### Rule 7: Use generic patterns — never hardcode domain examples

The first sentence describes the skill's *algorithm*, not a specific domain. Hardcoding examples (e.g., `Billing`, `Fleet`, `Order`) makes the skill look brittle outside that domain.

**Bad:**
```
detects misplaced domain models and ownership conflicts
(e.g., Billing owns invoice triggers, Fleet owns vehicle state)
```

**Good:**
```
detects misplaced domain models and documents ownership direction
(which context owns invariants, transitions, and side effects)
```

Domain-specific examples belong in the SKILL.md body or EXAMPLES.md.

### Rule 8: Add progressive disclosure hint for extended resources

When a skill has large assets or references, hint that the agent should load them only when needed:

```
...and load extended resource files only when their content is needed.
```

## Description vs body

| Layer | Role |
|-------|------|
| **Description first sentence** | When to use the skill + non-negotiable rules (router signal) |
| **Description after first period** | Triggers, secondary context |
| **SKILL.md body** | Full process, examples, templates, gates |

Changing the description improves selection and initial compliance. Changing the body changes the full procedure the agent follows after loading the skill.

## Workflow: Improving a weak description

1. Read the skill body and list hard gates / contracts that must never be missed.
2. Fold those into one first sentence (commas / em dashes, no early period).
3. Eliminate `... ` inside backticks; keep length ≤ 1024.
4. Put trigger words after the first period.
5. Re-read the first sentence alone — would an agent that only sees that sentence do the right thing?

## Ceiling

Some content cannot fit in a first sentence:

- Worked examples with specific domain values
- Long patterns-to-avoid lists
- Full reference file inventories

Hint at them (“document each concept with its invariant example and patterns to avoid”) and keep detail in the body.

## Cross-repo applicability

This strategy applies to any skill pack in the ecosystem:

| Repo | Role |
|------|------|
| ruby-core-skills | Ruby + process skills |
| agnostic-planning-skills | PM + planning skills |
| rails-agent-skills | Rails-specific skills |
| hanakai-yaku | Hanami/dry-rb/ROM skills |

Canonical skill inventory per repo is `directory.json`.
