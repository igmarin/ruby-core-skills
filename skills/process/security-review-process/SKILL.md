---
name: security-review-process
license: MIT
description: >
  Standardizes security review procedures for Ruby code. Mapped to OWASP Top 10
  vulnerabilities, input validation, secrets management, and dependency audits.
  Trigger words: security review, check security, audit code, security vulnerability,
  secrets check, OWASP.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# Security Review Process

A framework-agnostic process for auditing Ruby source code for security vulnerabilities.

## Quick Reference

| Area | Audit Rule |
|------|------------|
| **Input Validation** | Treat all external data as untrusted; allowlist fields |
| **Secrets** | Never hardcode keys/tokens; ensure they are excluded from logs |
| **Injections** | Use query parameters or parameterized variables; never interpolate strings in SQL |
| **Dependencies** | Perform regular dependency audits for CVEs |

## HARD-GATE

```text
SECURITY GATES:
1. NO secrets (keys, passwords, tokens) may be committed in source code or output in log messages.
2. Direct SQL interpolation (e.g. "WHERE id = #{id}") is FORBIDDEN. Use parameterized queries.
3. Untrusted external payloads must pass through an allowlist filter before processing.
4. Run bundle-audit or check dependencies for known vulnerabilities before finalizing changes.
```

## Process Steps

### Step 1: Input Validation Audit
- Identify all entry points (controllers, API endpoints, webhooks, console runners).
- Verify that every parameter is explicitly filtered (allowlisted) and type-coerced if necessary.
- Ensure that any instruction-like keys (e.g. `prompt`, `instructions`) in JSON payloads are discarded or neutralized.

### Step 2: Injections Check
- Audit all database interactions:
  - Verify that no raw SQL strings are created using string interpolation (`#{}`).
  - Ensure the database client's query parameterization features are used.
- Audit file and command executions:
  - Avoid executing shell commands dynamically via backticks (`` ` ``), `system()`, or `exec()`. If necessary, escape arguments or pass them as separate array items.

### Step 3: Secrets and Logs Check
- Ensure environment configurations are read from environment variables (`ENV['SECRET']`) or secure config vaults, not raw literals.
- Check logs: verify that sensitive data (passwords, tokens, personal identifiers) is filtered/redacted from log output.

### Step 4: Dependency and CVE Checks
- Scan project dependencies. Ensure a dependency auditor tool is run:
  ```bash
  bundle exec bundle-audit check --update
  ```
- If a vulnerability is reported, plan a safe version upgrade.

---

## Checkpoint Pattern

Align with the user:
1. **Security Vulnerability Assessment:** Present the list of security concerns categorizing by threat vector (e.g. SQL injection, Secrets leak).
2. **Mitigation verification:** Once fixes are made, demonstrate how the parameterized query or filter blocks the exploit vector.

---

## Code Defenses Examples

### 1. Preventing SQL Injection
**Vulnerable:**
```ruby
# String interpolation dynamically creates SQL query
db.execute("SELECT * FROM users WHERE name = '#{params[:name]}'")
```
**Secure:**
```ruby
# Param query prevents injection
db.execute("SELECT * FROM users WHERE name = ?", params[:name])
```

### 2. Preventing Shell Injection
**Vulnerable:**
```ruby
# Shell interprets dynamic string containing user input
system("rm -rf #{params[:path]}")
```
**Secure:**
```ruby
# Array arguments bypass shell interpreter
system("rm", "-rf", params[:path])
```

---

## Anti-Patterns

- **String-Interpolated SQL:** Assuming user input is safe because it passed through another service first.
- **Log Leakage:** Logging raw request payloads or configuration hashes that might contain credentials.
- **Outdated Dependencies:** Ignoring warnings about dependency vulnerabilities because "we don't use that part of the gem".

## Integration

| Context | Next Skill |
|---------|-----------|
| Standard code reviews | **review-process** |
| General TDD loops | **tdd-process** |
