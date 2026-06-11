# Hooks Directory

This directory contains agent hooks for automated code review.

## CLAUDE_PLUGIN_ROOT

The `hooks.json` file references `${CLAUDE_PLUGIN_ROOT}`, which is an environment variable set by Claude Code and compatible agent runtimes. It points to the root directory of the plugin/skill package.

When running outside of an agent runtime, you can:
1. Set `CLAUDE_PLUGIN_ROOT` manually to this directory
2. Or install the hook directly: `cp hooks/pre-commit-rs-guard .git/hooks/pre-commit`

## Available Hooks

### pre-commit-rs-guard

Runs `rs-guard --dry-run` on staged changes before each commit. This is advisory only — it will not block commits, but will show potential issues.

**Requirements:**
- `rs-guard` must be installed and in PATH
- `DEEPSEEK_API_KEY` must be set for API access
