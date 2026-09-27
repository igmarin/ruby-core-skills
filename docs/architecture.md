# Pack boundaries

This pack owns Ruby language patterns and shared Ruby workflows. Rails-specific conventions and framework behavior live in `rails-agent-skills`; planning and profile selection live in `agnostic-planning-skills`.

`directory.json` is the registry. `code-workflow` is the single Ruby process skill; use its mode for behavior changes, refactors, reviews, or security checks. Keep pattern cards focused and load optional examples only when needed.

Runtime rules belong in the selected skill. Repository-wide operating instructions belong in `AGENTS.md`; do not copy a shared contract into every prompt.
