---
name: tdd-process
license: MIT
description: >
  Enforces the universal Red-Green-Refactor process for test-driven development. Generates
  failing test cases, validates test failure before proceeding, gates implementation code
  behind passing red-phase checks, and guides refactoring only after tests are green.
  Use when the user requests TDD workflow, asks to write tests first, mentions
  Red-Green-Refactor methodology, or uses trigger words: TDD, test-first, test gate.
metadata:
  version: 1.0.0
  user-invocable: "true"
  type: "process-discipline"
---
# TDD Process

A standardized, tool-agnostic framework for executing the Red-Green-Refactor loop.

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
- **Verify the Failure:** Ensure it fails exactly on the assertion you wrote, proving the test is checking the right thing. A syntax error in the test file is not a valid RED state.
- **Test Design Checkpoint:** Present the test file/code and the test failure output to the user before starting implementation.

### Step 2: Implement (Green Phase)
- Write the simplest, most direct code to make the test pass.
- Run the test file. Once it is Green, proceed to Refactoring.
- **Implementation Checkpoint:** Present the minimal code implemented to pass the tests.

### Step 3: Refactor (Refactor Phase)
- Clean up duplication, naming, class structures, and documentation (e.g., YARD docs).
- Run the test suite after each micro-change to verify you have not broken behavior.
- Ensure the tests remain Green.

---

## Framework Example

Below is a standard pattern using RSpec.

### RSpec
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

---

## Integration

| Context | Next Skill |
|---------|-----------|
| Testing first slices | **test-planning-process** |
| Refactoring green code | **refactor-process** |
| Documenting public APIs | **write-yard-docs** |

## What This Skill Does NOT Cover
This skill does not define test runner configurations, matchers, framework integration helpers, or mock library selection.
