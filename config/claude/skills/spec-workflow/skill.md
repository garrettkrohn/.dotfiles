---
name: spec-workflow
description: Orchestrates full spec-driven development workflow from specification to implementation
---

You are orchestrating a complete spec-driven development workflow. This process takes the user from initial idea through to verified implementation.

## Workflow Phases

1. **Specification** (`spec-planner`) - Clarify requirements, assess risks, break into chunks, write detailed TDD spec
2. **Execution** - Implement code from spec (`spec-coder` or `spec-assistant`)
3. **Review** (`spec-reviewer`) - Verify implementation matches spec

## Shared State

All phases use `.claude/specs/` directory **in the current repository** for handoff:
- `<repo>/.claude/specs/spec.md` - Output from specification phase
- `<repo>/.claude/specs/review.md` - Output from review phase

**Important**: These files live in the project repository, NOT in the global `~/.claude/` directory.

## Execution Flow

### Start: Assess Current State

Check what already exists:
- If `.claude/specs/spec.md` exists → offer to skip specification or revise
- Otherwise → start from phase 1

### Phase 1: Specification

1. Ensure `.claude/specs/` directory exists (create if needed)
2. Invoke: `Skill(skill: "spec-planner")`
3. Wait for spec-planner to complete
4. Verify `.claude/specs/spec.md` was created in the current repo
5. Ask user: "Specification complete. Review the spec above. Ready to proceed to implementation? (or type 'revise' to adjust the spec)"

### Phase 2: Execution

After spec is complete, ask the user how they want to implement:

**Option A: Automated (`spec-coder`)**
- Claude writes the code following the spec
- Works chunk by chunk
- User reviews each chunk before proceeding

**Option B: Manual with assistance (`spec-assistant`)**  
- User writes the code themselves
- Claude opens files in tmux/neovim
- Claude provides context and answers questions

Ask user: "Ready to implement. Would you like:
1. `/spec-coder` - I'll write the code chunk by chunk
2. `/spec-assistant` - You write the code, I'll help and open files
3. Manual - Implement on your own with the spec

Which would you prefer?"

### Phase 3: Review

After implementation is complete, offer a critical review:

Ask user: "Ready to review your implementation against the spec?

`/spec-reviewer` will:
- Compare your git diff to the spec
- Check for security vulnerabilities
- Find bugs and edge cases
- Verify test coverage
- Flag any deviations from spec

Run review now?"

If user agrees:
1. Invoke: `Skill(skill: "spec-reviewer")`
2. Wait for reviewer to complete
3. Review report written to `.claude/specs/review.md`
4. Ask user: "Review complete. Check `.claude/specs/review.md` for findings. Would you like me to explain any issues in detail?"

## Important Guidelines

### Always Pause Between Phases

**Never automatically proceed** to the next phase without user confirmation. Each phase produces output that the user needs to review.

After each phase:
1. Summarize what was accomplished
2. Point to the output artifact (file location)
3. Explicitly ask if the user wants to proceed or revise
4. Wait for user response

### Handle Revisions

If the user wants to revise:
- Ask what they'd like to change
- Re-run the current phase with updated context
- Don't proceed until they're satisfied

### Support Partial Workflows

The user might want to:
- Only run specification (stop after phase 1)
- Start from an existing spec (skip phase 1)
- Run phases individually later

Support this by:
- Checking for existing artifacts at start
- Offering to skip or revise existing work
- Never forcing the full workflow

### Communicate Clearly

- State which phase is starting: "Starting Phase 1: Specification..."
- State which phase completed: "Phase 1 complete. Spec written to `.claude/specs/spec.md`"
- Show what's next: "Next: Phase 2 - Implementation"
- Be explicit about what skills are missing if any arise

## Usage Examples

```bash
# Start full workflow with a ticket
/spec-workflow
[user provides ticket or description]

# Resume from existing spec
/spec-workflow
# System detects spec.md exists and offers to continue from phase 2

# Just specification (user stops after phase 1)
/spec-workflow
[specification completes]
User: "Thanks, I'll implement this manually"
```

## Current Status

✅ **Phase 1: Specification** - `spec-planner` skill is ready (combined planning and spec writing)
✅ **Phase 2: Execution** - Two options available:
   - `spec-coder` - Automated implementation
   - `spec-assistant` - Manual implementation with help
✅ **Phase 3: Review** - `spec-reviewer` skill is ready

All phases of the spec-driven workflow are now available!
