# Registry Specification

> **Status:** Final — Phase 0 Deliverable
> **Date:** 2026-05-24
> **Scope:** `agent-mcp-runtime` registry resolution, pack system, deprecation handling, and dependency validation

---

## 1. Overview

This document specifies the central registry manifest (`registry.json`), pack resolution behavior, deprecation alias format, and `depends_on` validation rules. The runtime (`agent-mcp-runtime`) reads this manifest to resolve skills and agents across the ecosystem.

**Key design decision:** Pack-scoped resolution with a flat namespace. Framework packs take priority over core. No skill renames needed.

---

## 2. `registry.json` Schema

The central registry manifest lives in `agent-mcp-runtime` (or a well-known remote URL). It declares available packs, their sources, dependencies, and auto-detection rules.

```json
{
  "version": "1.0.0",
  "packs": {
    "core": {
      "source": "igmarin/ruby-core-skills",
      "tile": "tile.json",
      "always_loaded": true
    },
    "rails": {
      "source": "igmarin/rails-agent-skills",
      "tile": "tile.json",
      "depends_on": ["core"],
      "additional_packs": ["planning"]
    },
    "hanami": {
      "source": "igmarin/hanakai-yaku",
      "tile": "tile.json",
      "depends_on": ["core"],
      "additional_packs": ["planning"]
    },
    "planning": {
      "source": "igmarin/agnostic-planning-skills",
      "tile": "tile.json"
    }
  },
  "default_stack": ["core", "planning"],
  "auto_detect": {
    "rails": {
      "indicators": [
        "config/application.rb",
        "Gemfile:gem 'rails'",
        "Gemfile:gem \"rails\""
      ],
      "additional_packs": ["planning"]
    },
    "hanami": {
      "indicators": [
        "config/app.rb",
        "Gemfile:gem 'hanami'",
        "Gemfile:gem \"hanami\""
      ],
      "additional_packs": ["planning"]
    }
  }
}
```

### 2.1 Field Definitions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `version` | string | Yes | Registry manifest version. SemVer. |
| `packs` | object | Yes | Map of pack name → pack definition. |
| `packs.<name>.source` | string | Yes | GitHub repo slug (`owner/repo`). |
| `packs.<name>.tile` | string | Yes | Relative path to `tile.json` in the repo. |
| `packs.<name>.always_loaded` | boolean | No | If `true`, this pack is included in every resolution. Default: `false`. |
| `packs.<name>.depends_on` | array | No | List of pack names that must be loaded before this pack. |
| `packs.<name>.additional_packs` | array | No | Packs to auto-include when this pack is selected. |
| `default_stack` | array | Yes | Packs loaded when no framework is detected and no `--pack` is provided. |
| `auto_detect` | object | No | Framework detection rules. |
| `auto_detect.<name>.indicators` | array | Yes | List of file paths or `file:content` patterns to match. |
| `auto_detect.<name>.additional_packs` | array | No | Extra packs to include when this framework is detected. |

---

## 3. Auto-Detection Behavior (Hybrid with Loud Logging)

**Design rationale:** Explicit `--pack` selection is reliable but adds friction. Auto-detection is user-friendly but heuristics can be brittle. The hybrid model runs auto-detection by default, loudly reports what was found, and allows `--pack` to override. When detection is uncertain, the runtime warns and prompts for explicit selection.

### 3.1 Detection Algorithm

```
1. If --pack flag(s) provided:
   → Use only explicit packs + their depends_on + default_stack
   → Log: "Pack selection: explicit (--pack rails). Skipping auto-detection."
   → STOP

2. Scan working directory for auto_detect indicators:
   a. Read Gemfile (if present)
   b. Check for file existence matches (config/application.rb, config/app.rb)
   c. Score each framework by number of matched indicators

3. Evaluate confidence:
   - Score >= 2 indicators matched → HIGH confidence
   - Score == 1 indicator matched → MEDIUM confidence
   - Score == 0 indicators matched → NO detection

4. HIGH confidence:
   → Load detected framework pack + depends_on + additional_packs + default_stack
   → Log: "Detected: rails (high confidence). Loading packs: [rails, core, planning]."

5. MEDIUM confidence:
   → Load detected framework pack + depends_on + additional_packs + default_stack
   → Log WARNING: "Detected: rails (medium confidence — only 1 indicator). Use --pack rails to confirm."

6. NO detection:
   → Load default_stack only: [core, planning]
   → Log: "No framework detected. Loading default stack: [core, planning]. Use --pack <name> to override."

7. Multiple frameworks detected (edge case):
   → Log WARNING: "Ambiguous: detected both rails and hanami. Use --pack <name> to disambiguate."
   → Load default_stack only (no framework pack)
```

### 3.2 CLI Examples

```bash
# Auto-detect (default behavior)
agent-mcp-runtime --task "Add full_name to User model"
# Log: Detected: rails (high confidence). Loading packs: [rails, core, planning].

# Explicit override — skips auto-detection entirely
agent-mcp-runtime --pack rails --task "Add full_name to User model"
# Log: Pack selection: explicit (--pack rails). Skipping auto-detection.

# Multiple packs
agent-mcp-runtime --pack rails --pack planning --task "Review PRD and implement"
# Log: Pack selection: explicit (--pack rails, --pack planning).

# No framework — pure Ruby gem work
agent-mcp-runtime --task "Review my YARD docs"
# Log: No framework detected. Loading default stack: [core, planning].

# Ad-hoc local registry (development)
agent-mcp-runtime --pack rails --registry ./my-local-skills --task "Test my new skill"
# Log: Pack selection: explicit (--pack rails). Local registries: [./my-local-skills].
```

### 3.3 Confidence Scoring Table

| Framework | Indicator 1 | Indicator 2 | Indicator 3 |
|-----------|-------------|-------------|-------------|
| Rails | `config/application.rb` exists | `Gemfile` contains `gem 'rails'` | `Gemfile` contains `gem "rails"` |
| Hanami | `config/app.rb` exists | `Gemfile` contains `gem 'hanami'` | `Gemfile` contains `gem "hanami"` |

**Note:** Indicators are evaluated as OR conditions within a framework. A single strong indicator (e.g., `config/application.rb` for Rails) is sufficient for MEDIUM confidence. Multiple indicators yield HIGH confidence.

---

## 4. Resolution Order

Skills are resolved by searching packs in priority order. The first match wins.

### 4.1 Priority Stack (highest → lowest)

```
1. --registry ./local-path       (ad-hoc local override for development)
2. Explicit --pack <framework>    (rails or hanami)
3. ruby-core-skills              (always_loaded = true)
4. agnostic-planning-skills      (default_stack or explicit --pack planning)
5. Default fallback              (core + planning only)
```

### 4.2 Resolution Examples

**Scenario A: `--pack rails`**
```
"write-yard-docs"    → NOT in rails → FOUND in core → use core version
"load-context"       → FOUND in rails → use Rails version (stop searching)
"tdd-process"        → NOT in rails → FOUND in core → use core version
"implement-hotwire"  → FOUND in rails → use Rails version
"create-prd"         → NOT in rails → NOT in core → FOUND in planning → use it
```

**Scenario B: `--pack hanami`**
```
"write-yard-docs"    → NOT in hanami → FOUND in core → use core version
"load-context"       → FOUND in hanami → use Hanami version (stop searching)
"tdd-process"        → NOT in hanami → FOUND in core → use core version
"plan-tests"         → NOT in hanami → FOUND in core → use core version
"create-slice"       → FOUND in hanami → use Hanami version
```

**Scenario C: No framework detected**
```
"write-yard-docs"    → FOUND in core → use core version
"create-prd"         → NOT in core → FOUND in planning → use it
"load-context"       → NOT in core → NOT in planning → ERROR: Skill not found
```

### 4.3 Edge Case: Same Skill Name in Multiple Packs

If a skill name exists in both a framework pack and core (e.g., hypothetical future collision), the framework pack wins. The runtime does not merge skill content — it picks the highest-priority match.

**Logging behavior:** If the resolved skill is from a lower-priority pack while a higher-priority pack contains a skill with the same name, the runtime logs: `Resolved 'skill-name' from <pack> (higher priority pack <other-pack> has a different version).`

---

## 5. `depends_on` Validation

### 5.1 Validation Rules

At startup, the runtime validates that every loaded pack's dependencies are satisfied:

1. For each pack in the active stack, read its `depends_on` array (from `tile.json` or `registry.json`).
2. Verify that every dependency is present in the active stack.
3. If a dependency is missing, emit a WARNING (not fatal):
   ```
   "rails-agent-skills depends on ruby-core-skills, but core pack is not loaded."
   "Add --pack core or check your registry.json."
   ```

### 5.2 Circular Dependency Detection

If `depends_on` chains form a cycle (e.g., core depends on rails, rails depends on core), the runtime logs an ERROR and exits:
```
"Circular dependency detected: core → rails → core. Check registry.json and tile.json files."
```

### 5.3 `depends_on` in `tile.json`

Each framework repo's `tile.json` declares its dependency on core:

```json
{
  "name": "igmarin/rails-agent-skills",
  "version": "6.0.0",
  "depends_on": ["igmarin/ruby-core-skills"],
  "skills": { ... }
}
```

The runtime uses this for validation. The `depends_on` field is an array of repo slugs (not pack names) to support future cross-repo dependencies beyond the core framework.

---

## 6. Deprecation Alias Format

When skills are removed from framework repos in Phase 2, the origin repo's `tile.json` contains a `deprecated_skills` section. This provides a soft landing for existing users.

### 6.1 `tile.json` Deprecation Section

```json
{
  "name": "igmarin/rails-agent-skills",
  "version": "6.0.0",
  "depends_on": ["igmarin/ruby-core-skills"],
  "skills": {
    "generate-api-collection": { "path": "skills/api/generate-api-collection/SKILL.md" },
    "...": "..."
  },
  "deprecated_skills": {
    "write-yard-docs": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills. It will be resolved automatically via pack resolution.",
      "removed_in": "7.0.0"
    },
    "define-domain-language": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "review-domain-boundaries": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "model-domain": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "create-service-object": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "implement-calculator-pattern": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "integrate-api-client": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "triage-bug": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "respond-to-review": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    },
    "skill-router": {
      "moved_to": "igmarin/ruby-core-skills",
      "message": "This skill has moved to ruby-core-skills.",
      "removed_in": "7.0.0"
    }
  }
}
```

### 6.2 Runtime Deprecation Behavior

When a skill is requested by name:

1. Search active packs in priority order.
2. If found in a pack's `skills` section, use it (no deprecation).
3. If NOT found in any pack's `skills`, search all packs' `deprecated_skills`.
4. If found in `deprecated_skills`:
   a. Log: `⚠ Skill 'write-yard-docs' has moved to ruby-core-skills. Resolving from core pack.`
   b. Resolve the skill from the `moved_to` repo transparently (as if it were in that pack's `skills`).
   c. Continue execution normally.
5. If not found in `skills` or `deprecated_skills`, return ERROR: `Skill 'unknown-skill' not found in any loaded pack.`

### 6.3 Timeline

| Version | Action |
|---------|--------|
| v6.0.0 | Skills removed from `rails-agent-skills`. `deprecated_skills` entries added. Runtime resolves transparently. |
| v7.0.0 | `deprecated_skills` entries removed. Users must have updated their pack resolution or they will get "skill not found". |

---

## 7. Local Registry Override (`--registry`)

For development and testing, the runtime supports ad-hoc local skill directories.

### 7.1 Behavior

```bash
agent-mcp-runtime --pack rails --registry ./my-local-skills --task "Test my new skill"
```

- `--registry` accepts a local directory path.
- Multiple `--registry` flags are allowed. They are searched in declaration order.
- Local registries have **highest priority** — they override even framework packs.
- The directory must contain a valid `tile.json` at its root.
- If the local `tile.json` has a skill with the same name as a pack skill, the local version wins.

### 7.2 Use Cases

| Use Case | Command |
|----------|---------|
| Test a new skill before publishing | `--registry ./my-skill-draft --pack rails` |
| Override a single skill temporarily | `--registry ./skill-override --pack rails` |
| Debug pack resolution issues | `--registry ./debug-pack` (no --pack, to test core-only behavior) |

---

## 8. Registry Resolver (Pseudocode)

```rust
struct RegistryResolver {
    local_registries: Vec<LocalRegistry>,  // from --registry flags
    packs: Vec<Pack>,                       // from --pack flags + auto-detect + defaults
}

impl RegistryResolver {
    fn resolve_skill(&self, name: &str) -> Option<ResolvedSkill> {
        // 1. Check local registries first (dev override)
        for reg in &self.local_registries {
            if let Some(skill) = reg.find_skill(name) {
                return Some(skill);
            }
        }

        // 2. Check packs in priority order (framework > core > planning)
        for pack in &self.packs {
            // 2a. Check active skills
            if let Some(skill) = pack.find_skill(name) {
                return Some(skill);
            }
            // 2b. Check deprecated skills (transparent resolution)
            if let Some(deprecated) = pack.find_deprecated_skill(name) {
                log_warn!("Skill '{}' has moved to {}. Resolving from target pack.",
                          name, deprecated.moved_to);
                if let Some(target_pack) = self.find_pack_by_source(&deprecated.moved_to) {
                    if let Some(skill) = target_pack.find_skill(name) {
                        return Some(skill);
                    }
                }
            }
        }

        None
    }

    fn validate_dependencies(&self) -> Vec<Warning> {
        let mut warnings = vec![];
        for pack in &self.packs {
            if let Some(deps) = &pack.depends_on {
                for dep in deps {
                    if !self.packs.iter().any(|p| p.name == *dep) {
                        warnings.push(Warning::MissingDependency {
                            pack: pack.name.clone(),
                            dependency: dep.clone(),
                        });
                    }
                }
            }
        }
        warnings
    }
}
```

---

## Appendix A — MCP Tools Impact

The pack system affects these MCP tools:

| Tool | Behavior Change |
|------|-----------------|
| `list_skills` | Returns merged catalog from all loaded packs. Marks deprecated skills with `deprecated: true` and `moved_to` info. |
| `use_skill` | Resolves via `RegistryResolver::resolve_skill`. Transparently handles deprecated skills with warnings. |
| `list_agents` | Returns merged agent catalog. Agents from framework packs only (core has no agents). |
| `use_agent` | Loads agent + its declared dependencies. Validates cross-repo dependency chain. |
| `list_packs` | Shows available packs from `registry.json` and currently loaded packs. |

---

## Appendix B — Verification Checklist

- [ ] `registry.json` schema validates against a JSON Schema validator
- [ ] Auto-detection correctly identifies Rails projects (3 indicators)
- [ ] Auto-detection correctly identifies Hanami projects (3 indicators)
- [ ] `--pack rails` skips auto-detection entirely
- [ ] `--pack` without framework detection loads `default_stack` only
- [ ] `--registry ./local` overrides framework pack skills
- [ ] Missing `depends_on` emits a WARNING (non-fatal)
- [ ] Circular `depends_on` emits an ERROR (fatal)
- [ ] Deprecated skill resolution logs a warning and resolves transparently
- [ ] Skill not found in any pack returns a clear ERROR
