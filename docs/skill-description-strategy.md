# Skill Description Strategy

*Optimizing `description` metadata for Tessl baseline eval scores.*

## The Bottleneck

The Tessl eval task prompt includes only the **first sentence** of the skill's `description` metadata. The function `sentence_from_description` splits on `/(?<=[.!?])\s+/` — everything after the first `. ` (or `!` / `?` + space) is invisible to the agent in baseline mode.

The first sentence is the **only signal** the agent receives about the skill's specific conventions. The rest of the description, the SKILL.md body, assets, and examples are all invisible until the agent loads the skill explicitly.

## Diagnosis: Find the Bottleneck

For any skill repo:

```bash
# 1. Run the eval
tessl eval --tile <your-tile>

# 2. View results — note baseline scores <80%
tessl eval view --last

# 3. Check what the agent actually sees in the task prompt
cat tessl-evals/<skill-name>/scenario-0/task.md

# 4. Compare against the description frontmatter
head -15 skills/<category>/<skill-name>/SKILL.md
```

The task prompt shows only the description up to the first `. ` — if it looks generic, that's why the baseline score is low.

## Rules

### Rule 1: Pack all critical rules into the first sentence

Use one long sentence with commas, colons, and em dashes — no periods until the very end of the critical content:

```yaml
description: >
  Use when creating service classes with `self.call` entry point,
  `{success:, response:}` response contract, spec at `spec/services/...`,
  `UPPER_SNAKE_CASE` error constants, mandatory module README, and test BEFORE
  implementation. Covers 4 core patterns...
```

Everything up to the first `. ` becomes the task prompt. Everything after is invisible in baseline mode.

### Rule 2: Avoid `...` followed by whitespace

Backtick expressions like `{ ... } }` contain `...` followed by a space. The regex `(?<=[.!?])\s+` splits at the third `.` + space, truncating the first sentence mid-expression.

**Bad:** `{ success: true/false, response: { ... } }` → splits after `...`

**Good:** `{success: true/false, response: {...}}` → no space after `...`

Same rule applies anywhere three dots appear: `"..."` is fine (third dot followed by `"` not space), but `"..." }` triggers a split (third dot followed by ` }`).

Check for this in the generated task prompt — if the sentence is truncated at `...`, fix the space.

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

Trigger words are for skill selection — they don't need to be in the task prompt. Place them after the first period where they're available for selection but don't consume first-sentence space:

```
description: >
  Use when creating service classes with .call pattern, spec at
  spec/services/... MUST write test BEFORE implementation.
  Trigger words: service object, .call pattern, services.
```

### Rule 5: Watch for `?` in method names

The regex splits on `?` followed by whitespace. `should_calculate?` is fine (`?=` no space) but `should_calculate? ` with a trailing space would split. Avoid trailing spaces after question marks in the first sentence.

### Rule 6: Stay under the 1024-character limit

The `description` frontmatter field has a **1024-character maximum** (enforced at eval time). This includes indentation whitespace from YAML `>` folding. Backtick-heavy sentences burn through this quickly — be concise:

```yaml
# Bad — wastes chars on verbose connectors
Auth has `self.default`, `DEFAULT_TIMEOUT`, and cached `#token`.

# Good — uses `+` and compact phrasing
Auth has `self.default` + `DEFAULT_TIMEOUT` + cached `#token`.
```

Check length before running the eval:
```bash
ruby -ryaml -e '
md = File.read("skills/<category>/<skill>/SKILL.md")
_, yaml, _ = md.split(/^---\s*$/, 3)
puts YAML.safe_load(yaml)["description"].length
'
```

If over 1024, trim backticks, shorten connectors, or move less-critical rules after the first period.

### Rule 7: Use generic patterns — never hardcode domain examples

The first sentence describes the skill's *algorithm*, not a specific domain. Hardcoding examples (e.g., `Billing`, `Fleet`, `Order`) to match an eval instruction creates a fragile dependency and makes the skill look generic to users outside that domain.

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

Domain-specific examples belong in the SKILL.md body or EXAMPLES.md, where the agent reads them after loading the skill. The first sentence should express the pattern, not the instance.

### Rule 8: Add progressive disclosure hint for extended resources

Many skills generate an instruction like `"Load these files only when their specific content is needed"` — this tests whether the agent uses progressive disclosure. Add a brief hint at the end of the first sentence:

```
...and load extended resource files only when their content is needed.
```

This addresses the instruction directly without hardcoding file paths or names.

## Understanding the Scoring System

### Instructions come from the body, not the description

The eval criteria (instructions.json → criteria.json) are extracted from the SKILL.md **body**, not the description. Changing the description only affects the task.md problem statement that the agent sees. The instructions tested against the agent's output remain the same.

This means:
- **Description changes** improve how well the agent understands what to produce
- **Body changes** add/remove what criteria are tested
- Adding a new section to the body can introduce new instruction candidates that may score poorly if the description doesn't hint at them

### Scoring variance across runs

Single-run scores can fluctuate by ±10-15% for the same description due to LLM scorer variance. Run at least 2-3 times and average the results before declaring a change effective or ineffective. Compare runs with the same `--label` to track progress.

## Workflow: Fixing a Low-Scoring Skill

### Step 1: Read the instruction JSON

```bash
cat tessl-evals/<skill>/instructions.json
```

This shows the exact instructions the eval tests. Note which instructions score low.

### Step 2: Map instructions to description content

- Does the instruction test content that lives in the SKILL.md body?
- Can that rule be summarized in the first sentence?
- Is it a concrete example that's fundamentally invisible? (Accept lower baseline)

### Step 3: Edit the description

Edit the `description` field in `skills/<category>/<skill>/SKILL.md`:

1. Move critical rules before the first `. ` — use commas/em dashes instead
2. Eliminate `... ` (three dots followed by space) inside backticks
3. Keep the first sentence as one long sentence ending at the first period

### Step 4: Verify

```bash
ruby scripts/generate-tessl-evals.rb   # if your repo has this script
ruby scripts/validate-tessl-evals.rb
# Or your repo's equivalent
cat tessl-evals/<skill>/scenario-0/task.md  # confirm first sentence
```

### Step 5: Run eval

```bash
tessl eval --tile <your-tile>
tessl eval view --last
```

Check if the specific low-scoring instruction improved.

## The Ceiling

Some instructions test specific examples or content from the SKILL.md body that cannot fit in a first sentence:

- Worked examples with specific domain values (e.g., `Order must never transition from cancelled back to active`)
- Patterns-to-avoid lists with specific class names
- Extended reference loading instructions

These are fundamentally invisible in baseline mode. A first sentence can hint at them (e.g., "document each concept with its invariant example and patterns to avoid") but cannot embed the full content. Expect baseline scores of 60-70% for these.

## Measurement

### v1.0.0 → v1.1.0 (original application)
**Before: 54% baseline avg → After: 87% baseline avg**

| Skill | Before | After | Delta |
|-------|--------|-------|-------|
| refactor-process | 33% | 100% | +67 |
| generate-tdd-tasks | 20% | 97% | +77 |
| skill-router | 50% | 98% | +48 |
| integrate-api-client | 37% | 93% | +56 |
| create-service-object | 19% | 85% | +66 |
| implement-calculator-pattern | 41% | 82% | +41 |
| security-review-process | 52% | 84% | +32 |
| review-domain-boundaries | 52% | 74% | +22 |
| respond-to-review | 58% | 82% | +24 |
| tdd-process | 67% | 91% | +24 |
| write-yard-docs | 77% | 89% | +12 |
| test-planning-process | 75% | 88% | +13 |

### v1.1.0 → v2.0.0 (this session — security + edge-case push)
**Before: 79% baseline avg → After: 89% baseline avg**

| Skill | Before | After | Delta |
|-------|--------|-------|-------|
| respond-to-review | 47% | 98% | +51 |
| integrate-api-client | 42% | 91% | +49 |
| review-process | 71% | 100% | +29 |
| write-yard-docs | 89% | 96% | +7 |
| test-planning-process | 89% | 91% | +2 |
| review-domain-boundaries | 76% | 76%* | 0 |

\* At ceiling — the I3 instruction tests a concrete Billing/Fleet ownership example that can't fit in a first sentence. With-context score: 88%.

## Cross-Repo Applicability

This strategy applies to any repo with Tessl evals that use `sentence_from_description` (the standard Tessl eval generator):

| Repo | Description | Skills | Eval script |
|------|-------------|--------|-------------|
| ruby-core-skills | Ruby + process skills | 16 | `scripts/generate-tessl-evals.rb` |
| agnostic-planning-skills | PM + planning skills | 10 | (check scripts/) |
| rails-agent-skills | Rails-specific skills | 28 | (check scripts/) |
| hanakai-yaku | Hanami/dry-rb/ROM skills | 37 | (check scripts/) |

To apply: run the eval, check which skills score <80% baseline, fix their descriptions using the rules above, regenerate evals, and re-run.
