---
name: jira
description: Create and manage Jira tickets with pre-configured OFW organization context. Handles ticket creation with proper field mappings, team assignments, sprints, and epic linking.
disable-model-invocation: false
user-invocable: true
---

# Jira Ticket Management

You are helping create and manage Jira tickets for OurFamilyWizard. All organization-specific constants are pre-configured below.

## OFW Jira Configuration

### Atlassian Instance
- **Cloud ID**: `54266219-bf68-41ac-baee-19399badf400`
- **Site URL**: `ourfamilywizard.atlassian.net`

### User Information
- **Account ID**: `712020:4fcee739-06b2-49c4-8699-d105d4947199`
- **Name**: Garrett Krohn
- **Default Team**: Mercury
- **Role**: Senior Backend Engineer

### Custom Field Mappings
These custom fields are used across all projects:

- **Sprint**: `customfield_10020` (format: number, e.g., `6578`)
- **Epic Link**: `customfield_10014` (format: string, e.g., `"GRNG-648"`)
- **OFW Team**: `customfield_10043` (format: object with id, e.g., `{"id": "10071"}`)
- **Story Points**: `customfield_10026` (format: number)

### Team Options
Available teams and their IDs:

- **Mercury**: `10071` (Garrett's team)
- **Chronos**: `10068`
- **Gandalf**: `10069`
- **Growth**: `10070`
- **Pro**: `10092`
- **Architecture**: `10067`
- **QA Automation**: `10072`
- **Tech Debt**: `10093`
- **Customer Support**: `10073`

### Project Keys
Common project shortcuts:

- **JS**: Frontend JavaScript/TypeScript projects
- **GRNG**: Team Mercury/Kate main project board
- **BE**: Backend services

### Issue Types
Standard issue type names (case-sensitive):

- **Epic**: Large user stories (hierarchy level 1)
- **Story**: Functionality or feature (hierarchy level 0)
- **Task**: Small, distinct work (hierarchy level 0)
- **Sub-task**: Part of larger task (hierarchy level -1)
- **Defect**: Bug identified internally
- **Support Defect**: Bug from customer support
- **Spike**: Research/investigation work
- **Tech Debt**: Technical debt items
- **LaunchDarkly**: Feature flag tracking
- **Segment**: Event tracking tickets
- **Experiment**: A/B tests and experiments
- **Clean Up**: Cleanup items

## K.A.T.E. Team SDLC Pilot - Engineer-Owned Validation

**Status**: Active pilot for K.A.T.E. team (Web, iOS, Android platforms). Backend already operates this way.

**Owner**: Kate Permenter | **Stakeholders**: Julie Johnson (QA EM), Liz (PM)

### Ticket Requirements (Pre-Development Gate)

**CRITICAL**: Every ticket MUST have the following BEFORE moving to "In Development":

1. **Detailed Acceptance Criteria**
   - Specific, testable conditions with clear pass/fail criteria
   - NOT vague statements like "it should work"
   - Each AC must be independently verifiable
   - Include happy path, edge cases, and error states

2. **Test Plan**
   - Document WHAT will be tested, HOW, and on WHAT environment
   - Must cover: happy path, edge cases, error states
   - Specify the environment (local, staging, TestFlight, staging APK)

**If a ticket lacks clear AC or test plan**: The engineer is responsible for writing them before starting work, or flagging the ticket as not ready.

### PR Requirements (THE Gate)

The PR is the ONLY validation gate in this process. Every PR must include completed test evidence:

```markdown
## Test Evidence

### Acceptance Criteria Validation
- [ ] AC 1: [paste AC text] — PASS / FAIL / NOT TESTED
      Evidence: [screenshot, recording, curl output, or test name]
- [ ] AC 2: [paste AC text] — PASS / FAIL / NOT TESTED
      Evidence: [screenshot, recording, curl output, or test name]
(repeat for each AC)

### Unit Test Coverage
- New tests added: [count and brief description]
- Coverage on changed files: [X%]
- Files excluded from coverage and why: [list or "None"]

### Manual Validation
- Environment: [local / staging / TestFlight / staging APK]
- Happy path validated: [Yes/No — describe]
- Edge cases validated: [list what was tested]
- Error states validated: [list what was tested]

### Known Risks
- [Areas that need extra attention at regression, or "None"]
```

**PRs without completed test evidence will not be approved.**

### Technical Requirements

**Unit Test Coverage**:
- **80% line coverage minimum** on new and modified files (enforced by CI)
- Coverage measured on PR files only, not entire repo
- Tests must exercise AC behavior, not just hit line counts
- Invalid: tests that assert nothing, mock-only tests, snapshot-only tests

**What counts as evidence**:
- Screenshots, screen recordings, curl output, test names
- Actual validation against each AC with documented pass/fail
- Coverage reports showing 80%+ on changed files

**What does NOT count**:
- "Tested locally" without specifics
- "Works fine" without evidence
- Tests that only verify mocks return what you told them

### Process Changes from Current SDLC

**What changed**:
- ❌ No per-ticket QA gate during development (no "Ready for QA" → "In QA" → "Passed QA")
- ❌ No per-ticket regression testing by QA
- ✅ PR is THE gate — full validation with documented evidence required
- ✅ Engineers self-move through regression statuses (acknowledge ticket is in RC)
- ✅ QA does system-level regression on RC only (cross-feature, exploratory)

**What did NOT change**:
- QA still does system-level regression on release candidates
- Release cadence stays the same
- Regression statuses still exist in Jira
- LaunchDarkly flag strategy unchanged

**Dropped Jira statuses** (or engineers skip them):
- Next Build
- Ready for QA
- In QA
- Passed QA

### Scenario-Specific Requirements

**Feature Behind LaunchDarkly Flag**:
- Standard test evidence in PR
- Engineer validates in prod after flag flip
- Flag serves as rollback mechanism

**Feature Without Flag** (ships at deploy, no kill switch):
- **Higher bar on test evidence** — peer review of test evidence required (not just code review)
- More thorough edge case and error state validation
- Examples: copy changes, config changes, non-behavioral refactors, dependency upgrades

**Defects (Bugs)**:
- Same process as features
- Fix must include a test that would have caught the bug
- Test evidence proves bug is resolved AND original flow isn't regressed

**Cross-Platform Changes** (Backend + Mobile/Web):
- Each engineer validates their slice independently at PR
- Ticket owner confirms end-to-end integration
- QA's system-level regression is most valuable here

### Regression Ownership

- ❌ No per-ticket regression re-test on any platform
- ✅ Engineer self-moves through regression statuses (acknowledges ticket is in RC)
- ✅ QA does system-level regression on RC (cross-feature interactions, exploratory)
- ✅ If QA finds an issue traceable to your ticket, you own the fix

### Flag Flip Accountability

When a feature uses a flag:
1. Engineer who built it validates at flag flip in production
2. Monitor for issues post-flip
3. Own the rollback if needed (kill the flag)

### Enforcement

**At PR Review**:
- PRs without test evidence template completed → not approved
- Coverage below 80% on changed files → CI blocks merge
- Test evidence that's clearly insufficient → feedback and revision required

**If Quality Drops**:
- Track: bug escape rate, cycle time, regression kickbacks (sprint over sprint)
- Rollback trigger: meaningful increase in escaped bugs or critical regression that per-ticket QA would have caught
- This is a pilot, not permanent — revert if metrics show it's not working

### Summary for Ticket Creation

When creating tickets for K.A.T.E. team work (Web, iOS, Android):

1. **Always include detailed AC** in ticket description (specific, testable, clear pass/fail)
2. **Always include test plan** in ticket description (what, how, where to test)
3. **Add a note** reminding engineer that PR must include test evidence template
4. **Reference this process** if the ticket is the first for a new feature or complex work

Example addition to ticket descriptions:
```markdown
## Acceptance Criteria
- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [Edge case or error state criterion]

## Test Plan
- **Environment**: [local / staging / TestFlight / staging APK]
- **Happy Path**: [describe what to test]
- **Edge Cases**: [list scenarios]
- **Error States**: [list failure scenarios]

---
**Note**: This ticket follows the K.A.T.E. team SDLC pilot. PR must include completed test evidence template with AC validation, coverage metrics, and manual testing proof.
```

## Common Workflows

### Creating a New Ticket

**Required fields:**
- `cloudId`: Use constant `54266219-bf68-41ac-baee-19399badf400`
- `projectKey`: e.g., `"JS"` or `"GRNG"`
- `issueTypeName`: e.g., `"Story"`, `"Task"`, `"Defect"`
- `summary`: Ticket title
- `customfield_10043`: Team (required) - use `{"id": "10071"}` for Mercury

**Common optional fields:**
- `description`: Ticket description
- `assignee_account_id`: Default to `712020:4fcee739-06b2-49c4-8699-d105d4947199` (Garrett)
- `contentFormat`: Use `"markdown"` for descriptions
- `customfield_10014`: Parent epic key (e.g., `"GRNG-648"`)
- `customfield_10020`: Sprint ID (query current sprints first)

### Finding Active Sprints

Always query sprints before creating tickets to get the latest sprint IDs:

```jql
project = GRNG AND Sprint in openSprints() ORDER BY created DESC
```

This returns sprint objects with `customfield_10020` containing:
- `id`: Sprint ID (use this number)
- `name`: Sprint name (e.g., "May 12 | Team K.A.T.E.")
- `state`: "active", "future", or "closed"
- `startDate` and `endDate`

For future sprints:
```jql
project = GRNG AND Sprint in futureSprints() ORDER BY created DESC
```

### Inheriting Context from Parent Epic

When creating a ticket under a parent epic, check the parent for defaults:

```javascript
// Get parent epic details
mcp__atlassian__getJiraIssue({
  cloudId: "54266219-bf68-41ac-baee-19399badf400",
  issueIdOrKey: "GRNG-648",
  fields: ["customfield_10043", "labels", "summary"]
})

// Use parent's team if not specified
// Parent team is in fields.customfield_10043.id
```

### Example: Create Frontend Ticket

```json
{
  "cloudId": "54266219-bf68-41ac-baee-19399badf400",
  "projectKey": "JS",
  "issueTypeName": "Story",
  "summary": "Add new feature to dashboard",
  "description": "Implement the new dashboard widget",
  "assignee_account_id": "712020:4fcee739-06b2-49c4-8699-d105d4947199",
  "contentFormat": "markdown",
  "additional_fields": {
    "customfield_10014": "GRNG-648",
    "customfield_10020": 6578,
    "customfield_10043": {"id": "10071"}
  }
}
```

## Process for Creating Tickets

1. **Gather requirements** from user:
   - Project (default to JS for frontend, GRNG for team work)
   - Issue type (default to Story)
   - Summary/title
   - Parent epic (if specified)
   - Sprint preference (current/next/specific)

2. **Look up dynamic values**:
   - Query active/future sprints if sprint assignment is needed
   - If parent epic specified, get its team to inherit
   - Otherwise use Mercury (10071) as default team

3. **Create ticket** with:
   - All required fields
   - Team from parent or default to Mercury
   - Sprint if requested
   - Assigned to Garrett by default
   - Epic link if parent specified

4. **Return results**:
   - Ticket key (e.g., JS-6551)
   - Direct URL: `https://ourfamilywizard.atlassian.net/browse/{key}`
   - Brief confirmation of settings (team, sprint, parent)

## Tips

- **Always use the cloud ID constant** - never query for it
- **Always use Garrett's account ID** - it's constant
- **Team Mercury is the default** - only query parent if user specifies a different context
- **Sprint format is just the number** - not an array, not an object
- **Team format is an object** - `{"id": "10071"}`, not just the string
- **Content format** - use `"markdown"` for descriptions, it's simpler than ADF
- **JQL queries** - use `Sprint in openSprints()` for active, `Sprint in futureSprints()` for upcoming
- **Field names in additional_fields** - use the customfield_XXXXX key names

## Common Errors and Solutions

**"Cloud id isn't explicitly granted"**
- You used the wrong format - use the UUID, not the site URL

**"Number value expected as the Sprint id"**
- Sprint field expects just the number: `6578`, not `[6578]` or `"6578"`

**"OFW Team is required"**
- Must include `customfield_10043` with team object: `{"id": "10071"}`

**"Bad Request" on team field**
- Team must be an object with id property, not a string

## MCP Tools Available

These Atlassian MCP tools are available:
- `mcp__atlassian__atlassianUserInfo` - Get user info
- `mcp__atlassian__getJiraIssue` - Get issue details
- `mcp__atlassian__createJiraIssue` - Create new issue
- `mcp__atlassian__editJiraIssue` - Update existing issue
- `mcp__atlassian__searchJiraIssuesUsingJql` - Search with JQL
- `mcp__atlassian__getJiraProjectIssueTypesMetadata` - Get field metadata
- `mcp__atlassian__addCommentToJiraIssue` - Add comment
- `mcp__atlassian__getTransitionsForJiraIssue` - Get workflow transitions
- `mcp__atlassian__transitionJiraIssue` - Move ticket through workflow

Use ToolSearch to load these tools before calling them.
