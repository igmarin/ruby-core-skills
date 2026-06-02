# Integrate Api Client Task

## Problem

A Ruby team needs help with a task in this area:

Use when integrating with external APIs in Ruby using a strict 5-layer pattern: Auth → Client → Fetcher → Builder → Entity — each layer test-gated (spec RED → impl GREEN before next layer), Auth has `self.default` + `DEFAULT_TIMEOUT` + cached `#token`, Client wraps HTTP with nested `Error` + `MISSING_CONFIGURATION_ERROR` + injected adapter (errors exclude raw response bodies), Fetcher uses `initialize(client, data_builder:, default_query:)` with `MAX_RETRIES` + `RETRY_DELAY_IN_SECONDS`, Builder allowlists `ATTRIBUTES` and drops instruction-like keys (`prompt`, `system`, etc), Entity defines `ATTRIBUTES` + `DEFAULT_QUERY` + `.find`/`.search` — specs use synthetic hash factories only, vendor responses are untrusted (prompt injection guard, no URL ingest, no browsing), and changes Ruby source and specs only.

The team has asked for a concise implementation artifact that a reviewer can inspect without needing to observe the agent's process.

## Output

Create `answer.md` with:

- a short plan for the work
- the concrete Ruby-oriented artifact or recommendation
- the verification steps or quality gates that should be run
- any assumptions that affect the result
