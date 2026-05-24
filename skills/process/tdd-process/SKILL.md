---
name: tdd-process
license: MIT
description: >
  Enforces the universal Red-Green-Refactor process. Ensures failing tests exist
  and are run before writing any implementation code. Trigger words: TDD, Red-Green-Refactor,
  test-first, write tests first, test gate.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# TDD Process

A standardized, tool-agnostic framework for executing the Red-Green-Refactor loop.

## Quick Reference

| Phase | Core Rule | Checkpoint |
|-------|-----------|------------|
| **1. Red** | Write a test that fails for the correct reason | Pause to review the test design |
| **2. Green** | Write the minimum code required to make the test pass | Pause if implementation requires design choices |
| **3. Refactor** | Clean up code while keeping tests green | Run tests after every small cleanup step |

## HARD-GATE

```text
TESTS GATE IMPLEMENTATION:
NO implementation code may be written until a failing test exists and has been executed.
1. The test MUST exist and be run.
2. The test MUST fail for the correct reason (e.g. method missing, wrong output value), not due to syntax, configuration, or test setup errors.
3. The implementation code MUST be the minimal code required to pass the test.
4. The test MUST pass (turn Green) before refactoring or moving to the next feature slice.
5. Code refactoring is ONLY permitted when all tests are Green.
```

## Process Steps

### Step 1: Design the Test (Red Phase)
- Identify the smallest logical chunk of behavior to implement.
- Write a failing test asserting this behavior.
- Run the test suite on that specific file.
- **Verify the Failure:** Ensure it fails exactly on the assertion you wrote, proving the test is checking the right thing.

### Step 2: Implement (Green Phase)
- Write the simplest, most direct code to make the test pass.
- Do not add extra features, optimize performance, or write YARD docs yet.
- Run the test file. Once it is Green, proceed to Refactoring.

### Step 3: Refactor (Refactor Phase)
- Clean up duplication, naming, class structures, and documentation (e.g., YARD docs).
- Run the test suite after each micro-change to verify you have not broken behavior.
- Ensure the tests remain Green.

---

## Checkpoint Pattern

To ensure alignment, pause and present findings to the user at these key checkpoints:
1. **Test Design Checkpoint:** After writing the failing test(s) but before starting implementation. Present the test file/code and the test failure output.
2. **Implementation Checkpoint:** Once the tests turn Green. Present the minimal code implemented to pass the tests.

---

## RSpec and Minitest Examples

Below are standard patterns for both testing frameworks.

### Example A: RSpec
**Failing Test (RED):**
```ruby
# spec/user_spec.rb
RSpec.describe User do
  describe "#full_name" do
    it "combines first name and last name" do
      user = User.new(first_name: "Ada", last_name: "Lovelace")
      expect(user.full_name).to eq("Ada Lovelace")
    end
  end
end
```
*Failure command & output:*
```bash
$ bundle exec rspec spec/user_spec.rb
...
1 example, 1 failure
Failed examples:
rspec ./spec/user_spec.rb:4 # User#full_name combines first name and last name (NoMethodError: undefined method `full_name')
```

**Minimal Implementation (GREEN):**
```ruby
# lib/user.rb
class User
  def initialize(first_name:, last_name:)
    @first_name, @last_name = first_name, last_name
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end
end
```

### Example B: Minitest
**Failing Test (RED):**
```ruby
# test/user_test.rb
require "minitest/autorun"
require_relative "../lib/user"

class UserTest < Minitest::Test
  def test_full_name
    user = User.new(first_name: "Ada", last_name: "Lovelace")
    assert_equal "Ada Lovelace", user.full_name
  end
end
```
*Failure command & output:*
```bash
$ bundle exec ruby test/user_test.rb
...
NoMethodError: undefined method `full_name' for #<User:0x00007f...>
1 runs, 0 assertions, 0 failures, 1 errors, 0 skips
```

**Minimal Implementation (GREEN):**
Same implementation class as above. Running again results in:
```bash
$ bundle exec ruby test/user_test.rb
1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

---

## Anti-Patterns

- **Blind Implementation:** Writing logic first, then writing tests that "prove" it works. This risks coding incorrect behavior or writing un-testable code.
- **Unverified Failure:** Assuming a test fails correctly without running it. A syntax error in the test file is not a valid RED state.
- **Premature Optimization:** Refactoring or writing complex helper utilities during the Green phase. Keep it minimal first.

## Integration

| Context | Next Skill |
|---------|-----------|
| Testing first slices | **test-planning-process** |
| Refactoring green code | **refactor-process** |
| Documenting public APIs | **write-yard-docs** |

## What This Skill Does NOT Cover
This skill does not define test runner configurations, matchers, framework integration helpers, or mock library selection.
