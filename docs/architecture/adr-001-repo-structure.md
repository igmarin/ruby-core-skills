# ADR-001: Skill Ecosystem Repository Structure

> **Status:** Accepted
> **Date:** 2026-05-24
> **Author:** Ismael Marin + Devin (Architect Review)
> **Supersedes:** ADR-000 (monorepo skill registry, rejected)

---

## 1. Context

The AI skill ecosystem has grown to 85 skills across 3 active repositories, plus supporting tools:

| Repository | Role | Skills | Agents | Version |
|------------|------|--------|--------|---------|
| `rails-agent-skills` | Rails-specific skills + agents | 38 | 9 | v5.1.17 |
| `hanakai-yaku` | Hanami/dry-rb/ROM skills + agents | 37 | 10 | v0.2.2 |
| `agnostic-planning-skills` | Language-agnostic planning | 10 | 4 | v3.0.6 |
| `agent-mcp-runtime` | Rust CLI — ReAct loop + MCP server | — | — | — |
| `ruby-skill-bench` | Evaluation engine | — | — | — |
| `rails-ai-bridge` | Rails introspection (independent) | — | — | — |

**The core problem:** `rails-agent-skills` and `hanakai-yaku` have naming collisions on skills that are either (a) truly framework-agnostic Ruby skills that should not live in either repo, or (b) framework-specific skills with the same name but different content. Examples:

- `write-yard-docs` lives in `rails-agent-skills` but is pure Ruby documentation knowledge.
- `refactor-code` exists in both `rails-agent-skills` and `hanakai-yaku` with different content.
- `plan-tests` exists in both with framework-specific conventions.

Additionally, universal process knowledge (TDD gates, review severity taxonomy, refactoring discipline) is duplicated or fragmented across framework-specific skills and agents.

---

## 2. Decision

We will restructure the ecosystem into **4 separate skill repositories** with a **pack-based resolution system** in `agent-mcp-runtime`:

### 2.1 Repository Structure

| Repository | Skills | Agents | Purpose |
|------------|--------|--------|---------|
| **`ruby-core-skills`** (NEW) | ~15 | 0 | Shared Ruby atomic skills + process-discipline skills |
| `rails-agent-skills` | ~28 | 9 | Rails-specific skills + agents |
| `hanakai-yaku` | ~35 | 10 | Hanami/dry-rb/ROM skills + agents |
| `agnostic-planning-skills` | 10 | 4 | Language-agnostic planning (unchanged) |

### 2.2 Pack-Based Resolution

The runtime (`agent-mcp-runtime`) resolves skills by pack priority. No skill renames are needed:

```
--pack rails  →  search order: [rails-agent-skills, ruby-core-skills, agnostic-planning-skills]
--pack hanami →  search order: [hanakai-yaku, ruby-core-skills, agnostic-planning-skills]
(no --pack)   →  search order: [ruby-core-skills, agnostic-planning-skills]
```

Framework pack wins over core (CSS specificity model). Skills keep their short names.

### 2.3 Auto-Detection (Hybrid with Loud Logging)

The runtime attempts to auto-detect the framework from the working directory (`Gemfile`, `config/application.rb`, `config/app.rb`). Detection is logged loudly. `--pack` overrides auto-detection entirely. When detection is uncertain, the runtime warns and prompts for explicit selection.

### 2.4 Dependency Declaration

Framework repos declare their dependency on `ruby-core-skills` via `depends_on` in `tile.json`:

```json
{
  "name": "igmarin/rails-agent-skills",
  "version": "6.0.0",
  "depends_on": ["igmarin/ruby-core-skills"],
  "skills": { ... }
}
```

### 2.5 Deprecation Aliases

When skills are removed from framework repos, `deprecated_skills` entries in `tile.json` provide a soft landing:

```json
{
  "deprecated_skills": {
    "write-yard-docs": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    }
  }
}
```

### 2.6 Process-Discipline Skills

Universal process knowledge is extracted into 5 new skills in `ruby-core-skills`:

| Skill | Encodes |
|-------|---------|
| `tdd-process` | Red-Green-Refactor hard gates and checkpoints |
| `refactor-process` | Characterization tests first, small steps, verify-after-each |
| `review-process` | Severity taxonomy, structured findings, re-review criteria |
| `security-review-process` | OWASP checklist, Ruby-level security concerns |
| `test-planning-process` | Test-selection decision framework |

These are **skills**, not agents. Framework agents compose them with local framework skills.

### 2.7 No Generic Agents in Core

`ruby-core-skills` contains **zero agents**. A "generic TDD agent" without framework context is too abstract to be useful — it cannot know which test runner, assertion library, or directory conventions to use. The valuable shared part is the *process discipline* (encoded as skills), not the orchestration (which stays in framework repos).

---

## 3. Consequences

### 3.1 Positive

- **Clear ownership:** Every skill has an unambiguous home. No more "should this live in Rails or Hanami?"
- **Framework independence:** `ruby-core-skills` can be used for pure Ruby gems, Sinatra apps, or any future framework.
- **No skill renames:** Pack resolution handles disambiguation. `plan-tests` stays `plan-tests`.
- **Release independence:** Rails v6.0.0 and Hanami v0.3.0 can ship on different schedules.
- **Contributor focus:** New contributors clone only the repo they care about.
- **Process discipline is reusable:** Framework agents share the same hard gates (TDD, review, refactor) while retaining their framework context.

### 3.2 Negative

- **Breaking change:** Existing users of `rails-agent-skills` v5.x will see skills move. Mitigated by:
  - Major version bump (v5.x → v6.0.0)
  - Deprecation aliases with transparent resolution
  - Migration guide in CHANGELOG
- **Runtime complexity:** `agent-mcp-runtime` must implement pack resolver, dependency validation, and deprecation handling.
- **Cross-repo coordination:** Changes to core process skills may affect both framework repos. Core skills must be stable.
- **User-installed copy warnings:** Users who have copied skills into their local `.claude/` or `.cursor/` directories will have stale versions after Phase 2.

### 3.3 Neutral

- **4 repos instead of 3:** One new repo (`ruby-core-skills`) is added. Existing repos are not merged.
- **`agnostic-planning-skills` is unchanged:** It already had no collisions and no dependencies on framework repos.
- **`rails-ai-bridge` stays independent:** It is a data provider, not a skill repo. Future optional integration as a context provider for `load-context`.

---

## 4. Alternatives Considered

### 4.1 Monorepo Merge (REJECTED)

**Proposal:** Merge all skills into a single repository.

**Why rejected:**
- Previous monorepo was "too huge" — users hated cloning all frameworks.
- Coupled versioning: Hanami v0.2.2 bump would force Rails v5.1.17 to bump too.
- All frameworks tested on every push → slower CI/CD.
- Adding Sinatra/new framework would grow one repo forever.

**Evidence:** Direct user feedback rejected the previous monorepo experiment.

### 4.2 Skill Renames with Prefixes (REJECTED)

**Proposal:** Rename all skills to include framework prefix: `rails-plan-tests`, `ruby-yard-documentation`, `hanami-load-context`.

**Why rejected:**
- Most disruptive change: every `AGENTS.md`, `CLAUDE.md`, agent `SKILL.md`, and user-installed copy would need updating.
- Pack resolution handles disambiguation transparently.
- Skills in core should not have a `ruby-` prefix — they are the default.

### 4.3 Generic Agents in Core (REJECTED)

**Proposal:** Create generic agents in `ruby-core-skills` (e.g., `generic-tdd`, `generic-review`).

**Why rejected:**
- A generic TDD agent would need to answer: What test runner? What conventions? What commands?
- Without framework context, the agent is so abstract it provides almost no value.
- The valuable shared part is *process discipline* (gates, checkpoints) — that's a skill, not an agent.

### 4.4 Separate `ruby-agents` Repo (REJECTED)

**Proposal:** Create a `ruby-agents` repo for shared agent orchestrations.

**Why rejected:**
- There is no shared agent content to put there. Agents are inherently framework-specific.
- Would create an empty repo with no clear purpose.

### 4.5 Explicit `--pack` Only, No Auto-Detect (REJECTED in favor of hybrid)

**Proposal:** Require `--pack` on every invocation. No auto-detection.

**Why rejected:**
- Adds friction for the common case (user is in a Rails project and wants Rails skills).
- The hybrid model (auto-detect with loud logging + `--pack` override) provides the best of both worlds.

---

## 5. Related Decisions

| ADR | Title | Status | Relationship |
|-----|-------|--------|------------|
| ADR-002 | Pack Resolution Order and Priority | Proposed | Defines exact resolution algorithm |
| ADR-003 | Process-Discipline Skill Taxonomy | Proposed | Defines when to extract a process skill |
| ADR-004 | Deprecation Policy and Timeline | Proposed | Defines `removed_in` version rules |

---

## 6. Implementation Phases

| Phase | Timeline | Deliverables | Risk |
|-------|----------|--------------|------|
| Phase 0 | 1–2 days | Architecture docs (this ADR, classification, registry spec, process outlines) | Zero — docs only |
| Phase 1 | 2–3 days | Create `ruby-core-skills` repo with 15 skills, manifests, CI/CD | Low — purely additive |
| Phase 2 | 2–3 days | Remove duplicated skills from framework repos, add deprecation aliases, update agents | Medium — breaking change |
| Phase 3 | 3–5 days | Extend `agent-mcp-runtime` with pack resolver, `--pack`, `--registry`, dependency validation | Medium — runtime complexity |
| Phase 4+ | Future | Optional `rails-ai-bridge` integration as context provider | Low — independent |

---

## 7. Verification

- [ ] `ruby-core-skills` exists with 15 skills and 0 agents
- [ ] `rails-agent-skills` v6.0.0 has 28 skills, 9 agents, and `depends_on: [ruby-core-skills]`
- [ ] `hanakai-yaku` v0.3.0 has 35 skills, 10 agents, and `depends_on: [ruby-core-skills]`
- [ ] `agent-mcp-runtime` resolves skills by pack priority
- [ ] `--pack rails` loads Rails skills; `write-yard-docs` resolves from core
- [ ] Deprecated skills from v5.x resolve transparently with a warning
- [ ] No generic agents exist in `ruby-core-skills`
