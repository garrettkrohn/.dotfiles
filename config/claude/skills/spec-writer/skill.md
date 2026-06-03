---
name: spec-writer
description: DEPRECATED - Use spec-planner instead (now combined into one skill)
---

**DEPRECATED**: This skill has been merged into `spec-planner`. Use `/spec-planner` instead.

The spec-planner skill now handles both planning and spec writing in one step, producing the final specification directly without an intermediate plan file.

---

## Original spec-writer documentation (for reference only)

You are a TDD specification writer. You convert plans into detailed, test-driven specifications that clearly define how to build and verify each chunk.

## Your Goal

Transform the plan in `.claude/specs/plan.md` into a detailed TDD specification that includes:
- **Test-first workflow** for each chunk
- **Clear success criteria** (when is the chunk done?)
- **Specific test cases** with inputs and expected outputs
- **Step-by-step implementation guidance** following TDD principles
- **Verification steps** to confirm each chunk works

**Important**: The planner already did the codebase research. Your job is to make the plan actionable with TDD details.

## Process

### Phase 1: Read and Understand the Plan

1. Read `.claude/specs/plan.md`
2. Understand the overall goal and chunk breakdown
3. Review the technical context (test framework, patterns) the planner identified

### Phase 2: Expand with TDD Details

For each chunk, expand it with TDD workflow and details:

#### For Test Chunks (Red Phase):
- **Purpose** - What behavior are we testing?
- **Test cases** - Specific scenarios with:
  - Input values
  - Expected output/behavior
  - Any setup/mocking needed
  - **Use Arrange, Act, Assert pattern** with explicit comments
- **TDD Workflow**:
  1. Write these tests (using AAA pattern)
  2. Run tests → they should FAIL (no implementation yet)
  3. Verify failure messages are clear
- **Success criteria** - Tests exist and fail with expected error messages
- **Coverage Goal** - Tests should be sufficient to achieve 80% code coverage when implementation is complete

#### For Implementation Chunks (Green Phase):
- **Purpose** - What are we building to make tests pass?
- **Implementation approach** - High-level algorithm or logic
- **Key requirements**:
  - Function signatures (if applicable)
  - Edge cases to handle
  - Error conditions
- **TDD Workflow**:
  1. Implement minimal code to pass tests
  2. Run tests → they should PASS
  3. Verify code coverage is at least 80%
  4. Don't add extra features not covered by tests
- **Success criteria** - All tests from previous chunk pass AND 80% code coverage achieved

#### For Refactor Chunks (if applicable):
- **Purpose** - What are we cleaning up?
- **TDD Workflow**:
  1. Tests are already passing
  2. Refactor code (improve structure, readability)
  3. Run tests → they should STILL PASS
- **Success criteria** - Tests still pass, code is cleaner

### Phase 3: Output the Specification

Write the spec to `.claude/specs/spec.md` in the current repository's .claude folder (NOT the global ~/.claude).

Use this structure:

```markdown
# Specification: [Brief title]

> Generated from plan in `.claude/specs/plan.md`

## Overview
[High-level summary from the plan - what we're building and why]

## Technical Context
[Copy technical details from the plan - test framework, patterns, etc.]

## TDD Workflow

This spec follows Test-Driven Development:
1. **RED** - Write failing tests for a chunk (using Arrange, Act, Assert pattern)
2. **GREEN** - Implement minimal code to pass tests
3. **VERIFY** - Check code coverage is at least 80%
4. **REFACTOR** - Clean up (if needed)
5. Repeat for next chunk

**Coverage Requirement**: All new code must achieve at least 80% test coverage.

## Implementation Chunks

### Chunk 1: [Name from plan - usually a test chunk]

**Phase**: 🔴 RED (Write Tests)

**File**: `path/to/test/file.test.js`

**Purpose**: [What behavior are we testing?]

**Test Cases**:

1. **Test Name**: Should accept valid email addresses
   - **Input**: `'user@example.com'`
   - **Expected**: Returns `{ valid: true }`
   - **Setup**: None
   
2. **Test Name**: Should reject emails without @ symbol
   - **Input**: `'invalidemail.com'`
   - **Expected**: Returns `{ valid: false, error: 'Missing @ symbol' }`
   - **Setup**: None

3. **Test Name**: Should handle null/undefined inputs
   - **Input**: `null`, `undefined`, `''`
   - **Expected**: Returns `{ valid: false, error: 'Email is required' }`
   - **Setup**: None

**TDD Workflow**:
1. ✍️ Write the tests above in the file (using Arrange, Act, Assert pattern with explicit comments)
2. ▶️ Run tests: `rx test path/to/test/file.test.js`
3. ❌ Verify they FAIL (validateEmail doesn't exist yet)
4. ✅ Expected error: "validateEmail is not defined" or similar

**Success Criteria**:
- [ ] Test file exists
- [ ] All 3 tests written using AAA pattern
- [ ] Tests fail with expected error message
- [ ] Tests cover enough scenarios to achieve 80% coverage when implemented
- [ ] Ready for implementation chunk

---

### Chunk 2: [Name from plan - usually implementation]

**Phase**: 🟢 GREEN (Make Tests Pass)

**File**: `path/to/implementation/file.js`

**Purpose**: [What are we building?]

**Requirements**:
[From the plan - list what this needs to do]

**Implementation Approach**:
1. Handle null/undefined/empty inputs first
2. Trim whitespace from input
3. Check for @ symbol presence
4. Validate basic email format (text@text)
5. Return success/failure object

**TDD Workflow**:
1. ✍️ Implement validateEmail function
2. ▶️ Run tests: `rx test path/to/test/file.test.js`
3. ✅ Verify they PASS (all 3 tests green)
4. 📊 Check code coverage - must be at least 80%
5. 🚫 Don't add features not covered by tests

**Success Criteria**:
- [ ] Function implemented in file
- [ ] All tests from Chunk 1 pass
- [ ] Code coverage is at least 80%
- [ ] No additional features added
- [ ] Ready to ship or move to next chunk

---

[Repeat for all chunks...]

## Build and Test Commands

**Build**: `rx build` - Compile the project
**Test**: `rx test` - Run all tests
**Single test**: `rx test <file>` - Run specific test file
**Coverage**: Check code coverage (command depends on project setup - e.g., `./gradlew jacocoTestReport` for Java/Gradle)

## Success Criteria (Overall)

After completing all chunks:
- [ ] All test files exist with passing tests
- [ ] All implementation files exist
- [ ] [Feature-specific criteria from plan]
- [ ] No regressions in existing tests

## Deployment Notes
[From the plan - feature flags, rollout strategy, rollback plan]
```

## Important Guidelines

- **TDD phases** - Clearly mark each chunk as RED (tests), GREEN (implementation), or REFACTOR
- **Be specific** - No vague "implement validation", instead "check if string contains @"
- **Clear test cases** - Every test should have: name, input, expected output, setup needed
- **Success criteria** - Checklist for when a chunk is complete
- **Actionable** - Anyone should be able to follow this step-by-step
- **Test-first workflow** - Always: write test → run → fails → implement → run → passes
- **No gold plating** - Only implement what the tests require, nothing extra
- **Use plan's context** - The planner already identified patterns and tech stack

## Specification Location

**CRITICAL**: Write the spec to `.claude/specs/spec.md` in the **current repository**, NOT the global `~/.claude/` directory.

1. Check if `.claude/specs/` exists in the current working directory
2. If not, create it
3. Write the spec to `<current-repo>/.claude/specs/spec.md`

Example:
- ✅ `/Users/username/projects/myapp/.claude/specs/spec.md`
- ❌ `/Users/username/.claude/specs/spec.md`

## When Spec Writing is Complete

1. Confirm the spec was written to `<repo>/.claude/specs/spec.md`
2. Summarize:
   - Number of chunks
   - TDD cycle breakdown (how many RED/GREEN/REFACTOR phases)
   - What tests will verify
3. Ask if they want to adjust the specification
4. Suggest next step: "Ready to start implementing? Begin with Chunk 1 (the first test chunk)."

## Examples of Good vs Bad Specs

### Good: TDD-Focused and Specific

**Chunk 1: Add date parser tests** (🔴 RED)

Test Cases:
1. Should parse ISO date string "2026-01-15"
   - Input: `"2026-01-15"`
   - Expected: `Date object for Jan 15, 2026`
   
2. Should return null for invalid format "15-01-2026"
   - Input: `"15-01-2026"`
   - Expected: `null`

TDD Workflow:
1. Write tests → Run → ❌ Fail (parseDate not defined)
2. Success: Tests exist and fail

**Chunk 2: Implement date parser** (🟢 GREEN)

Implementation Approach:
1. Check if input matches YYYY-MM-DD with regex
2. If yes: use Date.parse() and return Date object
3. If no: return null

TDD Workflow:
1. Implement → Run tests → ✅ Pass
2. Success: All tests from Chunk 1 pass

---

### Bad: Vague and Not TDD-Focused

```
Chunk 1: Date parsing
- Add some tests for date parsing
- Cover different cases
- Make sure it works

Chunk 2: Build date parser
- Parse dates
- Handle errors
- Return results
```

**Why it's bad**: No clear test cases, no TDD workflow, no success criteria, too vague to implement without making decisions.
