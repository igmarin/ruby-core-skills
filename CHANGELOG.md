# Changelog

All notable changes to `ruby-core-skills` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Ecosystem validator script (`scripts/validate-ecosystem.rb`) to run cross-repo checks.
- GitHub Actions workflow (`.github/workflows/ecosystem-validation.yml`) to run the ecosystem validator.
- GitHub Actions workflow (`.github/workflows/tile-check.yml`) to perform local `tile.json` integrity validation.

## [1.1.8] - 2026-05-30

### Security
- `respond-to-review`: Added prompt injection guard to description first sentence (W011 — third-party content exposure). Review comments now explicitly described as untrusted outsider-authored text subject to injection protection.
- `integrate-api-client`: Added prompt injection guard to description first sentence (W011). Vendor responses explicitly described as untrusted runtime data with URL/browsing restrictions.

### Added
- `review-domain-boundaries`: Added Ownership Direction section to SKILL.md body with good/bad pattern table across 5 dimensions (state, trigger, validation, side-effect, crossing).
- `docs/skill-description-strategy.md`: Added Rule 6 (1024-char limit), Rule 7 (generic patterns, no hardcoded domain examples), Rule 8 (progressive disclosure hint), and "Understanding the Scoring System" section with instruction-source clarification and scoring variance guidance.

### Changed
- Skill descriptions packed with critical rules in first sentence per description strategy:
  - `integrate-api-client`: First sentence expanded from 123→816 chars (test-gating, layer contracts, security guard)
  - `respond-to-review`: Added restatement, command-execution guard, injection guard (baseline: 47%→98%)
  - `review-process`: Added scope creep and authorization checks (baseline: 71%→100%)
  - `write-yard-docs`: Added English-only, yard stats verification, progressive disclosure (baseline: 89%→96%)
  - `test-planning-process`: Expanded boundary descriptors (request for HTTP/JSON, service for invariants, unit for calculations) (baseline: 89%→91%)
  - `review-domain-boundaries`: Generic ownership direction language, output format, load-examples-only hint (baseline: 76%)
- Tessl eval baseline average improved from 79% to 89%; with-context average at 97%.
