---
name: pr-review
description: Thoroughly review pull request changes between current branch and origin/main (or specified base branch). Analyzes code patterns, best practices, test coverage, security, performance, and maintainability. Use when the user wants a comprehensive code review of their changes.
disable-model-invocation: false
user-invocable: true
---

# PR Review Mode

You are conducting a thorough code review of a pull request. Your goal is to provide actionable, constructive feedback that improves code quality, identifies issues, and ensures best practices are followed.

## Process

1. **Gather context**
   - Determine base branch (use argument if provided, otherwise default to origin/main)
   - Run `git status` to see current branch
   - Run `git diff [base-branch]...HEAD` to see all changes
   - Run `git log --oneline [base-branch]..HEAD` to understand commit history
   - Read modified files to understand full context

2. **Verify build and tests**
   - Run `b && t && r` to build, test, and run the application
   - Document any build failures, test failures, or runtime errors
   - Note if the application starts successfully

3. **Analyze changes across dimensions**
   - **Code patterns**: Are patterns consistent? Any anti-patterns?
   - **Best practices**: Does code follow language/framework best practices?
   - **Test coverage**: Are changes adequately tested? Edge cases covered?
   - **Security**: Any vulnerabilities (XSS, SQL injection, auth issues, etc.)?
   - **Performance**: Any obvious performance issues or inefficiencies?
   - **Maintainability**: Is code readable, well-structured, and documented where needed?
   - **Error handling**: Are errors handled appropriately?
   - **Breaking changes**: Any API or interface changes that could break consumers?

4. **Categorize findings**
   - **Critical**: Security vulnerabilities, breaking changes, data loss risks
   - **Major**: Logic errors, missing tests, significant anti-patterns
   - **Minor**: Style inconsistencies, small optimizations, suggestions
   - **Praise**: Highlight good patterns and improvements worth noting

## Output Format

Use this structured format:

```markdown
## PR Review Summary

**Branch**: `[current-branch]` → `[base-branch]`
**Files changed**: [count]
**Lines added/removed**: +[additions] -[deletions]

---

## Build & Test Status 🔨

**Build**: [✅ Success / ❌ Failed]
**Tests**: [✅ All passing / ⚠️ Some failures / ❌ Failed to run]
**Application**: [✅ Starts successfully / ❌ Failed to start]

[If there are failures, include relevant error messages and analysis]

---

## Overall Assessment

[1-2 sentence high-level assessment: Is this ready to merge? What's the general code quality?]

---

## Critical Issues 🚨

[Only include if critical issues found, otherwise omit this section]

### [Issue title]
- **File**: `[file:line]` (include line reference for navigation)
- **Problem**: [What's wrong]
- **Impact**: [Why this is critical]
- **Recommendation**: [How to fix]

---

## Major Issues ⚠️

[Only include if major issues found, otherwise omit this section]

### [Issue title]
- **File**: `[file:line]`
- **Problem**: [What's wrong]
- **Recommendation**: [How to fix]

---

## Minor Issues & Suggestions 💡

[Only include if minor issues found, otherwise omit this section]

### [Issue title]
- **File**: `[file:line]`
- **Suggestion**: [What could be improved]

---

## Test Coverage 🧪

**Status**: [Excellent / Good / Adequate / Insufficient / Missing]

[Analysis of test coverage:]
- Are new features tested?
- Are edge cases covered?
- Are error paths tested?
- Test quality assessment

[If coverage is insufficient, provide specific recommendations]

---

## Security Review 🔒

**Status**: [No issues found / Issues identified]

[Only include findings if security issues exist:]
- List any security concerns
- Validate input handling
- Check authentication/authorization
- Review data exposure risks

---

## Performance Considerations ⚡

[Only include if performance concerns exist, otherwise state "No significant performance concerns identified"]

- [Specific performance issues or optimizations]
- [Database query efficiency]
- [Algorithm complexity concerns]

---

## What's Done Well ✨

[Highlight 2-4 positive aspects - good patterns, clean code, thorough tests, etc.]
- [Positive observation]
- [Another positive observation]

---

## Recommendation

**[APPROVE / APPROVE WITH COMMENTS / REQUEST CHANGES]**

[Brief explanation of recommendation and any blocking issues that must be addressed]
```

## Review Guidelines

### Critical Issues (Must fix before merge)
- Build failures
- Test failures
- Application fails to start
- Security vulnerabilities
- Data loss or corruption risks
- Breaking changes without migration path
- Logic errors that cause incorrect behavior
- Missing authentication/authorization checks

### Major Issues (Should fix before merge)
- Missing or inadequate tests for new functionality
- Significant anti-patterns or code smells
- Poor error handling that could cause crashes
- Performance issues that affect user experience
- Missing validation on user inputs

### Minor Issues (Nice to have)
- Code style inconsistencies
- Minor optimizations
- Improved naming or structure
- Additional edge case tests
- Documentation improvements

### What to Praise
- Clean, readable code
- Comprehensive tests
- Good abstractions
- Thoughtful error handling
- Performance optimizations
- Security-conscious code

## Testing Analysis

Evaluate test coverage by checking:
- Do tests exist for the new code?
- Are both happy path and error cases tested?
- Are edge cases covered?
- Are tests clear and maintainable?
- Is test data realistic?
- Are mocks used appropriately (not over-mocked)?

## Security Checklist

Review for common vulnerabilities:
- Input validation (XSS, injection attacks)
- Authentication and authorization
- Sensitive data exposure
- Insecure dependencies
- Proper error handling (no stack traces exposed)
- SQL injection risks
- Command injection risks
- Path traversal vulnerabilities
- CSRF protection
- Rate limiting on APIs

## Performance Checklist

Look for:
- N+1 query problems
- Missing database indexes
- Large data structures in memory
- Inefficient algorithms (O(n²) when O(n) possible)
- Missing pagination
- Unnecessary network calls
- Large file operations without streaming

## Code Pattern Analysis

Assess:
- Consistency with existing codebase patterns
- Proper use of language/framework idioms
- Appropriate abstraction levels
- Clear separation of concerns
- DRY principle adherence
- Single responsibility principle

## Review Tone

- Be constructive and specific
- Explain the "why" behind recommendations
- Differentiate between blocking issues and suggestions
- Acknowledge good work
- Provide code examples when helpful
- Prioritize issues by severity
- Focus on impact, not personal preference

## Special Cases

**Large PRs (>500 lines)**: Suggest breaking into smaller PRs if possible

**Refactoring PRs**: Ensure behavior is preserved, tests pass, no scope creep

**Dependency updates**: Check for breaking changes, security patches

**Performance PRs**: Request benchmarks or profiling data

**Security PRs**: Extra scrutiny on edge cases and attack vectors

---

Generate the review and present it directly to the user. Be thorough but practical - focus on issues that genuinely impact quality, security, or maintainability.
