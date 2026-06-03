---
name: pr
description: Analyze git changes and generate succinct PR summaries with three sections - why changes were made, what was changed, and notes for reviewers. Use when the user wants to create or summarize pull request content.
disable-model-invocation: false
user-invocable: true
---

# PR Summary Mode

You are generating a pull request summary. Be as succinct as possible - reviewers need clarity, not prose.

## Process

1. **Gather changes**
   - Run `git diff` to see unstaged/staged changes
   - Run `git diff [base-branch]...HEAD` to see all commits in the branch
   - Run `git log --oneline [base-branch]..HEAD` to see commit history
   - Read any modified files if context is needed

2. **Analyze changes**
   - Identify the core purpose (bug fix, feature, refactor, etc.)
   - Determine what files/components were affected
   - Note any breaking changes, new dependencies, or gotchas

3. **Write summary**
   - Use the three-section format below
   - Keep each section to 3-5 bullet points maximum
   - Omit file references and line numbers
   - Use general, high-level descriptions

## Output Format

Use this exact structure:

```markdown
## Why these changes were made

[1-2 sentence explanation of the problem or goal]

[Business/technical context if relevant, e.g., ticket number]

## What was changed

- Added/updated/removed component: high-level description
- Another change: what was added/removed/modified
- [Use lowercase, general terms - no file paths or technical implementation details]

## Notes for reviewer

- [Brief, high-level notes about tricky areas or important considerations]
- [Keep it general - avoid implementation details]
```

## Writing Style

**DO:**
- Use lowercase for bullets (e.g., "added kafka consumer")
- Keep descriptions high-level and general
- Lead with action verbs: "added", "updated", "removed"
- Mention breaking changes prominently
- Be brief - 5-8 words per bullet maximum

**DON'T:**
- Include file paths, line numbers, or class names
- Describe implementation details (how it works)
- Use generic phrases like "various improvements"
- Include commit messages verbatim (synthesize them)
- Write paragraphs (use bullets)
- Over-explain obvious changes

## Examples

**Good:**
```markdown
## Why these changes were made

Adding email import tracking to Segment analytics for user behavior monitoring

Ticket APICAL-314 requires migrating email import notifications to Iterable via Segment events

## What was changed

- Added kafka topic consumer
- Created email import processor to track events to analytics
- Added data models for kafka deserialization and segment events
- Added conversion interceptor to support `byte[]` headers
- Added unit tests covering processor logic and edge cases

## Notes for reviewer

- Conversion interceptor applies globally to all kafka consumers
- Manual acknowledgment prevents message loss on errors
- Tests cover both happy path and edge cases
```

**Bad:**
```markdown
## Why these changes were made

- This PR makes some improvements to the analytics system to handle email imports and track them properly through various monitoring tools for better observability.

## What was changed

- Updated the application.yml configuration file to add a new Kafka topic consumer in the spring.cloud.stream.bindings section at line 74-76 with manual acknowledgment mode
- Created a new EmailImportProcessor class that implements the consumer logic with methods for processing events
- Added several new data model classes including EmailImportEvent, EmailImportSegmentEvent, and DraftEventDto
- Implemented HeaderConversionInterceptor with @GlobalChannelInterceptor annotation
- Added comprehensive unit tests

## Notes for reviewer

- The HeaderConversionInterceptor applies to all -in- channels via @GlobalChannelInterceptor annotation to ensure consistent header handling across all Kafka consumers
- Please review the test coverage carefully
- Let me know if you have questions
```

## Key Principles

1. **Maximum brevity** - 5-8 words per bullet, no file references
2. **High-level only** - what was added/changed, not where or how
3. **General over specific** - "added kafka consumer" not "added KafkaConsumer bean in AppConfig.java:45"
4. **Lowercase bullets** - casual tone, quick to scan
5. **Reviewer-focused** - what matters for review, not implementation details

Generate the summary and present it directly to the user.
