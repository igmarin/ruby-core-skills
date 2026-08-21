# Bug Triage Boundary Guide

Maps common bug shapes to the highest-value first failing test.

| Bug shape | Likely first test | Path example |
|-----------|-------------------|------|
| Wrong status code, params handling, response payload | Request or integration test | `spec/requests/` or `test/integration/` |
| Invalid state transition, validation, calculation | Unit or service test | `spec/models/` or `test/unit/` |
| Async side effect missing or duplicated | Worker/job or unit test | `spec/workers/` or `test/jobs/` |
| Component integration/configuration regression | Integration test | Component test suite path |
| Third-party mapping/parsing issue | Integration or client-layer test | `spec/services/module_name/` |

## Diagnosing the Right Layer

- **HTTP/API symptoms** (wrong status, wrong payload shape, redirect loops): start at request or integration level
- **Data symptoms** (wrong value saved, wrong validation message): start at unit or service class level
- **Timing/Async symptoms** (missing notification, job not enqueued): start at background worker or unit service level
- **Integration/Component symptoms** (module loading errors, route not found): use integration test or dummy app integration test

## When the Boundary Is Unclear

1. Write the test at the highest visible symptom boundary first.
2. Run it — if it fails for the wrong reason (e.g., test setup error), move down a layer.
3. The correct boundary is where the failure message directly names the missing behavior.
