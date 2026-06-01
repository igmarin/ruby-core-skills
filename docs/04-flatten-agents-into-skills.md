# Plan 4: Flatten Agents into Orchestrator Skills

**Status:** Draft / In-Review
**Priority:** After Plans 1 and 3
**Estimated effort:** 1 week
**Depends on:** Plan 1 (ecosystem cleanup)

---

## Objective

Move all agents from the `agents/` directory into their corresponding domain categories under `skills/` as **orchestrator** type skills across all three skill repositories (`rails-agent-skills`, `hanakai-yaku`, and `agnostic-planning-skills`). This eliminates the agents/skills conceptual confusion, standardizes the folder structure, and establishes a machine-readable workflow schema format for orchestrator skills.

---

## Rationale & Architectural Decisions

* **Eliminating "Agent" Confusion:** Current "agents" are deterministic workflows (TDD loop, review loop, background job setup) rather than autonomous agents with ReAct loops or tool-selection capabilities. Renaming them to "orchestrators" or "workflows" is architecturally honest.
* **Category-Based Cohesion:** Instead of dumping all orchestrators into a flat `skills/workflows/` directory, orchestrator skills will be located in their domain-specific categories (e.g., `skills/testing/practice-tdd/SKILL.md`) alongside their corresponding atomic skills.
* **Metadata-Level Distinction:** The distinction between atomic and orchestrator skills will be handled at the metadata level inside YAML frontmatter using the `type` attribute:
  - `type: atomic` (single-purpose capability)
  - `type: orchestrator` (multi-step workflow/action)
* **Standardized Workflow Schema:** To make workflows machine-readable and deterministic for AI Agents/LLMs (Cursor, Claude Code, Codex, Custom runtimes), each orchestrator will declare a structured `workflow` block in its frontmatter. This describes phases, sequential actions, required sub-skills, and verification/hard-gates.

---

## The Workflow frontmatter Schema

Every orchestrator skill MUST include a `workflow` definition in its YAML frontmatter. This format is fully LLM-agnostic and allows runtimes to parse steps, load skills on demand, and enforce gates.

```yaml
---
name: verb-noun-action
type: orchestrator
license: MIT
description: >
  Single-sentence summary of the workflow action, optimized for Tessl baseline scores.
  Trigger words: ...
metadata:
  version: 1.0.0
  user-invocable: "true"
  dependencies:
    - source: self
      skills: [load-context, plan-tests]
    - source: ruby-core-skills
      skills: [tdd-process]
workflow:
  phases:
    - name: phase-name
      description: "Description of the phase"
      actions:
        - name: action-step-name
          purpose: "What this step does"
          required_skills: [dependent-skill-name]
          gate: "Checkpoint description (e.g. user approval or test suite pass)"
---
```

---

## Step-by-Step Migration Plan

### Phase 1: Repository Mappings

Each repository will migrate its `agents/` content to the corresponding category folders under `skills/` using `verb-noun` names:

#### 1. `igmarin/rails-agent-skills` Mappings
* `agents/tdd/SKILL.md` $\rightarrow$ `skills/testing/practice-tdd/SKILL.md`
* `agents/bug-fix/SKILL.md` $\rightarrow$ `skills/testing/resolve-bug/SKILL.md`
* `agents/review/SKILL.md` $\rightarrow$ `skills/code-quality/review-code/SKILL.md`
* `agents/quality/SKILL.md` $\rightarrow$ `skills/code-quality/improve-code-quality/SKILL.md`
* `agents/setup/SKILL.md` $\rightarrow$ `skills/context/initialize-environment/SKILL.md`
* `agents/engine/SKILL.md` $\rightarrow$ `skills/engines/integrate-engine/SKILL.md`
* `agents/graphql/SKILL.md` $\rightarrow$ `skills/api/integrate-graphql-api/SKILL.md`
* `agents/migration/SKILL.md` $\rightarrow$ `skills/infrastructure/apply-migration/SKILL.md`
* `agents/background-job/SKILL.md` $\rightarrow$ `skills/infrastructure/schedule-background-job/SKILL.md`

#### 2. `igmarin/hanakai-yaku` Mappings
* `agents/tdd-loop/` $\rightarrow$ `skills/testing/practice-tdd/SKILL.md`
* `agents/add-background-jobs/` $\rightarrow$ `skills/infrastructure/schedule-background-job/SKILL.md`
* `agents/add-table-column/` $\rightarrow$ `skills/db/add-table-column/SKILL.md`
* `agents/build-api-slice/` $\rightarrow$ `skills/slices/build-api-slice/SKILL.md`
* `agents/build-crud-resource/` $\rightarrow$ `skills/slices/build-crud-resource/SKILL.md`
* `agents/create-new-slice/` $\rightarrow$ `skills/slices/create-new-slice/SKILL.md`
* `agents/hanami-setup/` $\rightarrow$ `skills/cli/setup-hanami/SKILL.md`
* `agents/setup-authentication/` $\rightarrow$ `skills/cross-cutting/configure-authentication/SKILL.md`
* `agents/slice-lifecycle/` $\rightarrow$ `skills/slices/manage-slice-lifecycle/SKILL.md`
* `agents/validation-contract/` $\rightarrow$ `skills/dry-rb/validate-data/SKILL.md`

#### 3. `igmarin/agnostic-planning-skills` Mappings
* `agents/delivery-lead/` $\rightarrow$ `skills/ceremony/orchestrate-delivery/SKILL.md`
* `agents/product-owner/` $\rightarrow$ `skills/backlog/manage-product-backlog/SKILL.md`
* `agents/project-manager/` $\rightarrow$ `skills/execution/manage-project/SKILL.md`
* `agents/tech-lead/` $\rightarrow$ `skills/execution/guide-technical-design/SKILL.md`

---

### Phase 2: Updating Documentation & Configuration

To make this a clean, major upgrade, all configuration files, registries, and documentation must be systematically updated to remove the word "Agent" in favor of "Orchestrator Skill", "Workflow", or "Action".

#### 1. Manifest & Code Updates (All Repos)
* **Delete `agents.json`**: Completely remove from all repos.
* **Delete `agents/` folders**: Ensure no references or subfolders remain.
* **Update `.tessl-plugin/plugin.json`**: Add/move all skill paths to the `"skills": []` array under their new paths.
* **Update `directory.json` / `registry.json`**: Update references to match the new category folder structure.
* **Bump Major Versions**: All three repos must bump to version `7.0.0` to reflect this breaking change.

#### 2. Documentation Updates (ruby-core-skills & others)
* **Rename & Rewrite `AGENTS.md` $\rightarrow$ `ORCHESTRATORS.md`**:
  - Explain the unified skill model (`type: atomic` vs `type: orchestrator`).
  - Instruct how agents should execute orchestrator workflows and pass process gates.
* **Update `README.md`**:
  - Update skill counts (e.g. from "28 skills + 9 agents" to "37 skills").
  - Document the category structure where orchestrators reside within their domains.
  - Replace the "Agent Guidance" section with "Orchestrator Skill Guidance".
* **Update `CLAUDE.md` and `GEMINI.md`**:
  - Align terminology to remove "agent" references (except where referring to the user's IDE agent client like Cursor or Claude Code).
  - Update skill paths in tables to their new domain-specific categories.
* **Update Architecture Specifications**:
  - **`docs/architecture/agent-dependency-spec.md` $\rightarrow$ `docs/architecture/orchestration-dependency-spec.md`**: Update the specification to reflect the `workflow` metadata block, replacing the term "Agent" with "Orchestrator".
  - **`docs/architecture/adr-001-repo-structure.md`**: Append a section noting that Plan 4 supersedes the "zero agents in core" terminology to "zero orchestrators in core", aligning everything with the `type: atomic | orchestrator` model.
  - **`docs/architecture/skill-classification.md`**: Update the maps and post-migration inventories to reflect orchestrator names and domain-specific category paths.
  - **`docs/index.md`**: Update category tables to include the newly moved orchestrator skills within their domain lists.

---

## Detailed Execution Checklist

Use this checklist during execution to ensure a clean process:

- [ ] Create a migration branch in the target repo (e.g., `git checkout -b chore/flatten-agents-into-skills`).
- [ ] Create directories for orchestrators inside their domain category folders (e.g., `mkdir -p skills/testing/practice-tdd`).
- [ ] Move the `SKILL.md` from `agents/<name>/` to its new `skills/<category>/<new-name>/` directory.
- [ ] Update frontmatter metadata:
  - [ ] Add `type: orchestrator`.
  - [ ] Add the standardized `workflow` YAML block with phases, actions, sub-skills, and gates.
  - [ ] Optimize the `description` first-sentence format for Tessl baseline scores.
- [ ] Update occurrences of `# <Name> Agent` to `# <Name> Workflow` or `# <Name> Action` in the file headers and contents.
- [ ] Remove obsolete files:
  - [ ] `rm agents.json`
  - [ ] `rm -rf agents/`
- [ ] Update `.tessl-plugin/plugin.json` / `directory.json` to place the skill under `"skills"` with its new name and path.
- [ ] Rename/rewrite `AGENTS.md` to `ORCHESTRATORS.md`.
- [ ] Update `README.md`, `CLAUDE.md`, and `GEMINI.md` to match the new counts, categories, and unified skill terminology.
- [ ] Update specs and ADRs in `docs/architecture/` with updated names, paths, and metadata definitions.
- [ ] Verify using baseline generators and validators:
  - [ ] Run `ruby scripts/validate-tessl-evals.rb` (if available) or target validators.
  - [ ] Ensure all markdown links (`file:///...`) point to active, valid paths.
- [ ] Commit changes, bump version to `7.0.0` in package files, and request pull request review.
