# Repository guidance

- `directory.json` is the skill registry. Keep each registered path valid.
- This pack owns Ruby language and application patterns; Rails-specific conventions live in `rails-agent-skills`.
- `code-workflow` is the sole Ruby process skill; keep its modes short and behavior-specific.
- Keep examples and templates opt-in unless a skill needs them on every invocation.
- Run `ruby scripts/validate-ecosystem.rb` after registry or cross-pack changes.
