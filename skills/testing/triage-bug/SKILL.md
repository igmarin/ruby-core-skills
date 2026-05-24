---
name: triage-bug
license: MIT
description: >
  Use when investigating a bug, error, or regression in a Ruby codebase.
  Creates a failing reproduction test, isolates the broken code path, and
  produces a minimal fix plan. Trigger words: debug, broken, error, regression,
  stack trace, failing test, bug report, Ruby bug.
metadata:
  version: 1.0.0
  user-invocable: "true"
  origin: "Extracted from igmarin/rails-agent-skills v5.1.17"
---
# Triage Bug

## Quick Reference

| Bug shape | Likely first spec/test |
|-----------|-------------------|
| HTTP/API symptoms (status, JSON, redirect) | Integration/Request spec or controller test |
| Data/logic symptoms (wrong value, validation) | Unit or service test |
| Timing/Async symptoms (missing job, email) | Background worker or unit test |
| Integration/dependency regression | Component/integration test |

## HARD-GATE

```text
DO NOT guess at fixes without a reproduction path.
1. Reproduce the bug.
2. Choose the right failing test boundary.
3. Plan the smallest safe repair.
```

## Core Process

1. **Capture the report:** Restate the expected behavior, actual behavior, and reproduction steps.
2. **Bound the scope:** Identify whether the issue appears in request handling, domain logic, background workers, integration boundaries, or an external dependency.
3. **Gather current evidence:** Logs, error messages, edge-case inputs, recent changes, or missing guards.
4. **Choose the first failing test:** Pick the boundary where the bug is visible to users or operators.
5. **Define the smallest fix path:** Name the likely files and the narrowest behavior change that should make the test pass.
6. **Hand off:** Continue through `test-planning-process` -> `tdd-process` -> implementation skill.

### Canonical Request-Boundary Example

When the report is an order creation failure visible through an API request `POST /orders`, default to the request boundary first:

- **First failing test:** `spec/requests/orders_spec.rb` (or `test/integration/orders_test.rb`)
- **Command:** `bundle exec rspec spec/requests/orders_spec.rb` (or `bundle exec ruby test/integration/orders_test.rb`)
- **Expected RED:** response is not `422` with `"Out of stock"` yet, or the service raises instead of returning a handled error.
- **Smallest fix path:** `Orders::CreateOrder` handles the stock guard and returns `{ success: false, error: "Out of stock" }` without creating the order.

Do not replace this with a pricing, model-only, or class-only example unless the bug report points there.

### Boundary Guide

See [BOUNDARY_GUIDE.md](./BOUNDARY_GUIDE.md) for the full bug-shape → test-type mapping and layer diagnosis tips.

### Pitfalls

| Pitfall | What to do |
|---------|------------|
| Unit test when the bug is visible at request level | Start where the failure is actually observed |
| Bundling reproduction, refactor, and new features | Fix the bug in the smallest safe slice only |
| Flaky evidence treated as green light to patch | Stabilize reproduction before touching code |
| The explanation relies on "probably" or "maybe" | Ambiguity means the reproduction step isn't done yet |

## Extended Resources

- [BOUNDARY_GUIDE.md](./BOUNDARY_GUIDE.md)
- [assets/examples.md](assets/examples.md)

## Output Style

1. **Triage shape**:
   - **Observed behavior**
   - **Expected behavior**
   - **Likely boundary**
   - **First failing test to add**
   - **Smallest safe fix path**
   - **Follow-up skills**
   - **Exact command to run before the fix**
2. **Skeleton test**: Provide a skeleton failing test/spec to run before implementing the fix.
   *Example using RSpec:*
   ```ruby
   # spec/requests/orders_spec.rb
   RSpec.describe "POST /orders" do
     context "when product is out of stock" do
       let(:product) { Product.new(stock: 0) }

       it "returns 422 with an error message" do
         post "/orders", params: { product_id: product.id, quantity: 1 }
         expect(response.status).to eq(422)
         expect(response.body).to include("Out of stock")
       end
     end
   end
   ```
   *Example using Minitest:*
   ```ruby
   # test/integration/orders_test.rb
   class OrdersTest < Minitest::Test
     def test_order_creation_out_of_stock
       product = Product.new(stock: 0)
       post "/orders", { product_id: product.id, quantity: 1 }
       assert_equal 422, response.status
       assert_includes response.body, "Out of stock"
     end
   end
   ```
3. **Language**: Must be in English unless explicitly requested otherwise.

## Integration

| Skill | When to chain |
|-------|---------------|
| **test-planning-process** | To choose the strongest first failing test for the bug |
| **tdd-process** | To run the TDD loop correctly after the test is chosen |
| **refactor-process** | When the bug sits inside a risky refactor area and behavior must be preserved first |
| **review-process** | To review the final bug fix for regressions and missing coverage |
