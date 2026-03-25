---
name: jira-workflow
description: Use when implementing features or bugfixes tracked in Jira, before starting code modifications, and when managing the GitLab Merge Request lifecycle.
---

# Jira Development Workflow

## Overview
This skill defines the standard workflow for developing new features using Jira for issue tracking and GitLab for source control. It ensures that all work is tied to an existing Jira ticket and that the development process is documented directly within Jira and GitLab.

## When to Use
- You have been assigned a Jira ticket (e.g., `ISSUE-XXXX`).
- You are starting the research or implementation of a task.
- You need to open a GitLab Merge Request for a Jira-tracked task.

### When NOT to Use
- Do NOT use this if the task is not tracked in Jira.
- Do NOT use this to create new Jira tickets.

## Core Pattern

### 1. Identify Existing Jira Ticket
You MUST be provided with an existing Jira Ticket ID (e.g., `ISSUE-XXXX`).
**CRITICAL: NEVER CREATE JIRA TICKETS YOURSELF.** If no ticket is provided, ask the user for one.

### 2. Update Workspace
Always ensure your local repository is up to date before branching.
The default branch of the repository can have the name `master` or `main`. You can use the following command to figure out the default branch of the repository:
```bash
git rev-parse --abbrev-ref origin/HEAD
```
Then checkout the default branch (e.g., `main` or `master`) and pull the latest changes:
```bash
git checkout <DEFAULT_BRANCH>
git pull
```

### 3. Research and Create Plan
Analyze the Jira ticket and create an implementation plan. 
**DO NOT CREATE A GITLAB ISSUE.**

### 4. Identify Jira Environment (cloudId)
Before making Atlassian MCP tool calls, you must identify the correct `cloudId` for the Jira environment. 
Run the following tool to list accessible resources:
```bash
# mcp_Atlassian_getAccessibleAtlassianResources()
```
Identify the correct resource from the list and use its `id` as the `cloudId` parameter in subsequent Jira tool calls.

### 5. Submit Plan as Jira Comment
Submit your implementation plan as a comment to the existing Jira ticket using the Atlassian MCP.
```bash
# Example tool call:
# mcp_Atlassian_addCommentToJiraIssue(
#   cloudId="YOUR_CLOUD_ID",
#   issueIdOrKey="ISSUE-XXXX", 
#   commentBody="### Implementation Plan\n\n1. Task A...\n2. Task B..."
# )
```

### 6. Create Feature Branch
Checkout a new feature branch. The branch name MUST be the Jira Issue ID.
```bash
git checkout -b ISSUE-XXXX
```

### 7. Implement and Test
Execute the implementation plan following Test-Driven Development (TDD).

### 8. Push and Create Merge Request
When implementation is complete and tests pass, push the branch and open a Merge Request.
**MR Title Template:** `<JIRA TICKET ID>: [feature name]`
**MR Description Template:** `Summary of the changes in markdown format... Closes <JIRA TICKET ID>`

```bash
git push -u origin ISSUE-XXXX
glab mr create --title "ISSUE-XXXX: [feature name]" --description "Summary of the changes in markdown format... Closes ISSUE-XXXX"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Using a hardcoded cloudId | Always use `mcp_Atlassian_getAccessibleAtlassianResources` to find the correct `cloudId` for the current environment. |
| Creating a new Jira ticket | Use ONLY existing tickets provided by the user. |
| Creating a GitLab issue | Skip GitLab issue creation; use Jira comments for the plan. |
| Incorrect MR title | Follow the `<JIRA TICKET ID>: [feature name]` format exactly. |
| Incorrect MR description | Ensure it starts with a summary and ends with `Closes <JIRA TICKET ID>`. |
| Forgetting to pull main | Always run `git checkout main && git pull` before branching. |

## Red Flags - STOP and Correct
- **Creating any ticket or issue (Jira or GitLab).**
- Submitting an MR without the mandatory title prefix.
- Putting the implementation plan in a GitLab issue instead of a Jira comment.
- Implementing code before getting a Jira Ticket ID.
- Branching from an outdated `main`.
