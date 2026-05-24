# Process-Discipline Skill Outlines

> **Status:** Final — Phase 0 Deliverable
> **Date:** 2026-05-24
> **Scope:** Structural outlines for the 5 new process-discipline skills in `ruby-core-skills`
> **Note:** These are blueprints, not full SKILL.md content. Full content is written in Phase 1.

---

## 1. Overview

Process-discipline skills encode universal workflow knowledge — the "how to think about" a process — without any framework-specific content. They live in `ruby-core-skills` and are composed by framework agents to enforce discipline (hard gates, checkpoints) while retaining framework context.

**General format for each process skill:**

```markdown
---
name: [skill-name]
license: MIT
description: >
  [One-line description. Trigger words: ...]
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---

# [Skill Title]

## Quick Reference

| Topic | Rule |
|-------|------|
| ... | ... |

## HARD-GATE

[Non-negotiable checkpoints]

## Process Steps

[Numbered steps describing the universal process]

## Checkpoint Pattern

[When to pause for human review]

## Anti-Patterns

[Common mistakes this process prevents]

## Integration

| Context | Next Skill |
|---------|-----------|
| ... | ... |

## What This Skill Does NOT Cover

[Explicit exclusions — framework-specific content that stays in framework repos]
```

---

## 2. Outline: `tdd-process`

### 2.1 Purpose
Encodes the universal Red-Green-Refactor cycle with hard gates and checkpoints. This skill does not tell you *which* test framework to use — it tells you the discipline of writing a failing test first, implementing minimally, and refactoring only on green.

### 2.2 Source Material
- `rails-agent-skills/skills/testing/write-tests/SKILL.md` — HARD-GATE section
- `hanakai-yaku/agents/tdd-loop/SKILL.md` — cycle definition
- `rails-agent-skills/CLAUDE.md` — "CROSS-CUTTING MANDATE: Tests Gate Implementation"

### 2.3 Key Sections

| Section | Content |
|---------|---------|
| **Quick Reference** | 5-phase cycle table: Red → Green → Refactor → Review → Document |
| **HARD-GATE** | 5 non-negotiable checkpoints |
| **Process Steps** | Detailed walkthrough of each phase with decision criteria |
| **Checkpoint Pattern** | When to pause for human review (after test design, after implementation approach) |
| **Refactor Discipline** | Rules for safe refactoring (only after green, behavior-preserving, one step at a time) |
| **Cycle Exit Criteria** | Conditions for exiting the TDD loop (all tests green, code reviewed, docs written) |
| **Anti-Patterns** | Writing implementation before test, skipping verify-failure, refactoring on red, over-engineering |
| **Integration** | Links to `test-planning-process` (before) and `review-process` / `write-yard-docs` (after) |

### 2.4 Hard Gates

1. **Test EXISTS** — A test file has been created with at least one test case.
2. **Test RUNS** — The test executes without syntax errors, load errors, or infrastructure failures.
3. **Test FAILS for correct reason** — The test fails, and the failure message confirms the feature is missing (not a typo, wrong assertion, or unrelated error).
4. **Implementation is MINIMAL** — The smallest possible code change that makes the test pass. No speculative generality.
5. **Test PASSES after implementation** — The test passes, and no previously passing tests have broken.

### 2.5 What Is NOT In This Skill

- Which test runner to use (RSpec, Minitest, Hanami test suite)
- Which assertion library or matcher syntax
- Factory vs fixture vs test data setup patterns
- Framework-specific test types (request spec, model spec, action spec, ROM spec)
- CI/CD pipeline configuration
- Code coverage tooling

---

## 3. Outline: `refactor-process`

### 3.1 Purpose
Encodes the discipline of safe refactoring: characterize the existing behavior, make small steps, and verify after each step. This skill protects against the most common refactoring hazard — changing behavior while "cleaning up."

### 3.2 Source Material
- `rails-agent-skills/skills/code-quality/refactor-code/SKILL.md` — characterization tests, step size rules
- `hanakai-yaku/skills/refactor-code/SKILL.md` — Hanami-specific refactoring patterns (extract universal parts)

### 3.3 Key Sections

| Section | Content |
|---------|---------|
| **Quick Reference** | Pre-refactor → Step → Verify loop table |
| **HARD-GATE** | 4 non-negotiable checkpoints |
| **Pre-Refactor Gate** | Characterization tests must exist and pass before any refactoring begins |
| **Step Size Rules** | One transformation per commit; rename before extract; extract before move |
| **Verify-After-Each-Step** | Run full test suite after every atomic change |
| **Behavior Preservation Checklist** | Public API unchanged; side effects unchanged; performance not degraded |
| **Common Refactoring Patterns** | Extract method/class, rename, inline, decompose conditional, replace conditional with polymorphism |
| **Anti-Patterns** | Big-bang refactoring, refactoring without tests, refactoring on red, premature abstraction |
| **Integration** | Links to `tdd-process` (if tests need writing first) and `review-process` (after) |

### 3.4 Hard Gates

1. **Characterization tests EXIST and PASS** — Before refactoring, there must be tests that document current behavior. If none exist, write them first.
2. **Each refactoring step is atomic** — One rename, one extract, one move. No multi-step mega-refactorings in a single commit.
3. **Tests PASS after each step** — The full test suite must pass after every atomic change. If tests fail, revert and try a smaller step.
4. **No behavior change introduced** — Public method signatures, return values, and side effects must be identical before and after.

### 3.5 What Is NOT In This Skill

- Rails-specific refactoring patterns (fat controller → service object, concern extraction, ActiveRecord model decomposition)
- Hanami-specific patterns (slice extraction, provider refactoring, action reorganization)
- Framework-specific directory conventions (`app/services/`, `slices/`, etc.)
- Performance optimization (see `optimize-performance` in Rails pack)
- Database migration strategies for refactoring

---

## 4. Outline: `review-process`

### 4.1 Purpose
Encodes structured code review with severity levels and re-review criteria. This skill ensures every review produces actionable, categorized feedback and clear criteria for when re-review is required.

### 4.2 Source Material
- `rails-agent-skills/skills/code-quality/code-review/SKILL.md` — severity taxonomy, findings format
- `hanakai-yaku/skills/cross-cutting/review-code/SKILL.md` — Hanami-specific review concerns (extract universal parts)

### 4.3 Key Sections

| Section | Content |
|---------|---------|
| **Quick Reference** | Severity table + re-review criteria at a glance |
| **HARD-GATE** | 3 non-negotiable checkpoints |
| **Severity Taxonomy** | Critical (blocks merge), Major (should fix), Minor (nice to fix), Nitpick (style only) |
| **Review Checklist** | Structure, tests, documentation, security, performance, naming, error handling |
| **Findings Format** | Standardized template: location, severity, description, suggestion, rationale |
| **Self-Review Checklist** | Steps to take before requesting external review |
| **Re-Review Criteria** | When re-review is required vs. when approval can be granted |
| **Anti-Patterns** | Nitpicks without context, subjective opinions without rationale, missing severity labels |
| **Integration** | Links to `security-review-process` (security concerns) and `respond-to-review` (feedback response) |

### 4.4 Hard Gates

1. **Every finding has a severity** — No unlabeled feedback. Every comment must map to Critical, Major, Minor, or Nitpick.
2. **Critical findings block merge** — Any Critical finding must be resolved and re-reviewed before the PR can merge.
3. **Re-review required if any Critical finding was addressed** — Once a Critical finding is fixed, the changed code must be re-reviewed. You cannot self-approve a Critical fix.

### 4.5 What Is NOT In This Skill

- Rails-specific review concerns (N+1 queries, ActiveRecord anti-patterns, Strong Parameters usage)
- Hanami-specific concerns (DI patterns, slice boundaries, ROM conventions, provider misuse)
- Framework-specific tooling (Brakeman, RuboCop rules, Reek configuration)
- GitHub PR mechanics (approvals, merge strategies, branch protection)
- Team-specific style guides (those live in framework repos or project docs)

---

## 5. Outline: `security-review-process`

### 5.1 Purpose
Encodes Ruby-level security review based on OWASP and common Ruby vulnerabilities. This skill provides a checklist for identifying security issues in any Ruby codebase, regardless of framework.

### 5.2 Source Material
- `rails-agent-skills/skills/code-quality/security-check/SKILL.md` — Ruby-level parts (mass assignment, SQL injection, secrets)
- `hanakai-yaku/skills/review-security/SKILL.md` — Ruby-level parts (input validation, auth patterns)

### 5.3 Key Sections

| Section | Content |
|---------|---------|
| **Quick Reference** | OWASP Top 10 → Ruby checklist mapping |
| **HARD-GATE** | 3 non-negotiable checkpoints |
| **OWASP Top 10 Mapped to Ruby** | Injection, Broken Auth, Sensitive Data Exposure, XXE, Broken Access Control, Security Misconfiguration, XSS, Insecure Deserialization, Components with Known Vulnerabilities, Insufficient Logging |
| **Input Validation Checklist** | Whitelist over blacklist, type coercion, boundary checking, regex safety |
| **Authentication/Authorization Patterns** | Password storage (bcrypt), session management, token handling, role-based access |
| **Dependency Audit** | `bundle audit` / `gem audit` equivalents, CVE checking, lockfile review |
| **Secrets Management** | No secrets in code, no secrets in logs, environment variable usage, secret rotation |
| **Anti-Patterns** | Rolling own crypto, trusting client input, logging sensitive data, ignoring CVEs |
| **Integration** | Links to `review-process` (severity classification of security findings) |

### 5.4 Hard Gates

1. **Every input is validated** — All user-provided data (params, headers, files, JSON payloads) is validated before use. No raw input reaches business logic.
2. **No secrets in code or logs** — No API keys, database passwords, or private tokens in source code or log output. Secrets live in environment variables or dedicated secret stores.
3. **Dependencies checked for CVEs** — Known vulnerable dependencies are identified and upgraded. No "ignore CVE" without documented risk acceptance.

### 5.5 What Is NOT In This Skill

- Brakeman (Rails-specific static analysis tool)
- `strong_parameters` or Action Controller parameter handling (Rails-specific)
- CSRF token handling (framework-specific implementation)
- Hanami action-level security patterns (Hanami-specific)
- Infrastructure security (firewalls, VPCs, TLS termination)
- Compliance frameworks (SOC 2, HIPAA, GDPR process — these are organizational, not code-level)

---

## 6. Outline: `test-planning-process`

### 6.1 Purpose
Decision framework for choosing what type of test to write and where. This skill answers the universal question: "I need to test this change — what kind of test should I write first?"

### 6.2 Source Material
- `rails-agent-skills/skills/testing/plan-tests/SKILL.md` — test-selection logic, boundary identification
- `hanakai-yaku/skills/testing/plan-tests/SKILL.md` — Hanami-specific test conventions (extract universal parts)

### 6.3 Key Sections

| Section | Content |
|---------|---------|
| **Quick Reference** | Test type decision tree (flowchart in table form) |
| **HARD-GATE** | 3 non-negotiable checkpoints |
| **Test Type Decision Tree** | Unit → Integration → Request/System → E2E. Criteria for choosing each level. |
| **Coverage Strategy** | Happy path + boundary + error cases. When to stop adding tests. |
| **Boundary Identification** | Equivalence partitioning, edge cases, off-by-one errors, nil/empty handling |
| **First Failing Test Selection** | Which test to write first when multiple boundaries exist |
| **Test Isolation Principles** | No test should depend on another test's state or output |
| **Anti-Patterns** | Testing implementation instead of behavior, over-mocking, testing getters/setters, ignoring sad paths |
| **Integration** | Links to `tdd-process` (after planning, enter the TDD cycle) |

### 6.4 Hard Gates

1. **Test type is chosen with explicit reasoning** — The decision to write a unit vs integration vs request test is documented with rationale (e.g., "Unit test: logic is pure Ruby, no framework dependencies").
2. **Boundary cases are identified** — Before writing the first test, at least one boundary condition is identified and will be tested.
3. **Happy path + at least one sad path** — Every tested behavior includes the expected success case and at least one failure/edge case.

### 6.5 What Is NOT In This Skill

- RSpec-specific matchers, syntax, or shared examples
- Hanami test conventions (request spec vs action spec vs ROM spec)
- Factory vs fixture vs test data builder strategy
- Specific test file paths (`spec/models/`, `spec/slices/`, etc.)
- CI test parallelization or test suite performance optimization
- Coverage percentage targets (these are team/project policies)

---

## 7. Cross-Cutting Concerns

### 7.1 Shared Properties of All Process Skills

| Property | Value |
|----------|-------|
| **User-invocable** | Yes (`metadata.user-invocable: "true"`) |
| **Type** | `process-discipline` |
| **Agents** | None (process skills are not agents) |
| **Framework references** | None (no "Rails", "Hanami", "ActiveRecord", "ROM" in skill body) |
| **Hard gates** | Explicit, numbered, non-negotiable |

### 7.2 How Framework Agents Compose Process Skills

**Example: Rails `tdd` agent workflow**

```
Phase 1: load-context (local)          → Rails schema, routes, patterns
Phase 2: plan-tests (local)            → RSpec request/model/service selection
         test-planning-process (core)  → Ensure test type chosen with reasoning
Phase 3: write-tests (local)            → Rails-specific RSpec patterns
         tdd-process (core)            → HARD GATE: test EXISTS, RUNS, FAILS
Phase 4: implement                      → Minimal code to pass
         tdd-process (core)            → HARD GATE: test PASSES
Phase 5: write-yard-docs (core)         → Document public Ruby API
         code-review (local)           → Rails-specific review
```

**Example: Hanami `tdd-loop` agent workflow**

```
Phase 1: load-context (local)          → Slices, providers, routes
Phase 2: plan-tests (local)            → Request/action/relation spec selection
         test-planning-process (core)  → Ensure test type chosen with reasoning
Phase 3: write-request-spec (local)     → Hanami request spec patterns
         tdd-process (core)            → HARD GATE: test EXISTS, RUNS, FAILS
Phase 4: implement                      → Minimal code to pass
         tdd-process (core)            → HARD GATE: test PASSES
Phase 5: review-code (local)           → Hanami-specific review
```

---

## Appendix A — Verification Checklist

- [ ] All 5 process skills have `type: "process-discipline"` in frontmatter
- [ ] All 5 process skills have `user-invocable: "true"`
- [ ] No process skill body contains framework-specific terms ("Rails", "Hanami", "ActiveRecord", "ROM", "RSpec")
- [ ] Every hard gate is numbered and explicitly labeled as non-negotiable
- [ ] Every process skill has an "Integration" table linking to next skills
- [ ] Every process skill has a "What This Skill Does NOT Cover" section with explicit exclusions
- [ ] Process skill names do not conflict with existing framework skill names (they use `-process` suffix)
