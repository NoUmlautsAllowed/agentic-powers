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

### 0. Atlassian CLI Access
This skill requires the **Atlassian CLI `acli`** to be available. 
- All Jira operations must be performed using the `acli` command.
- Ensure you are authenticated with `acli auth login` if not already.
- You can check your authentication status with `acli auth status`.

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
Analyze the Jira ticket content using `acli jira workitem view ISSUE-XXXX` and create an implementation plan. 
**DO NOT CREATE A GITLAB ISSUE.**

### 4. Submit Plan as Jira Comment
Submit your implementation plan as a comment to the existing Jira ticket using `acli`. 
If the implementation plan is written to a file, you can use the `--body-file` option.

```bash
acli jira workitem comment create --key ISSUE-XXXX --body "Implementation Plan\n\n1. Task A...\n2. Task B..."
# Or using a file:
acli jira workitem comment create --key ISSUE-XXXX --body-file plan.txt
```

### 5. Create Feature Branch
Checkout a new feature branch. The branch name MUST be the Jira Issue ID.
```bash
git checkout -b ISSUE-XXXX
```

### 6. Implement and Test
Execute the implementation plan following Test-Driven Development (TDD).

### 7. Push and Create Merge Request
When implementation is complete and tests pass, push the branch and open a Merge Request.
**The MR description MUST be in Markdown format.**

**MR Title Template:** `<JIRA TICKET ID>: [feature name]`
**MR Description Template:** 
```markdown
### Summary of changes
- [Brief list of changes]

Closes <JIRA TICKET ID>
```
**Note: GitLab fully supports Markdown for MR descriptions.**

```bash
git push -u origin ISSUE-XXXX
glab mr create --title "ISSUE-XXXX: [feature name]" --description "### Summary of changes
- [Brief list of changes]

Closes ISSUE-XXXX"
```

### 9. Add MR Link as Jira Comment
After creating the GitLab MR, add a link to the MR as a comment to the Jira Issue.
You can get the MR link from the output of the `glab mr create` command. 

```bash
acli jira workitem comment create --key ISSUE-XXXX --body "GitLab Merge Request: [MR URL]"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Not using Atlassian CLI | Ensure the **Atlassian CLI `acli`** is available and used for all Jira operations. |
| Creating a new Jira ticket | Use ONLY existing tickets provided by the user. |
| Creating a GitLab issue | Skip GitLab issue creation; use Jira comments for the plan. |
| Missing MR link in Jira | Ensure the GitLab MR link is added as a comment to the Jira Issue. |
| Incorrect MR title | Follow the `<JIRA TICKET ID>: [feature name]` format exactly. |
| Non-Markdown MR description | Always use Markdown (headers, bullets) for MR descriptions. |
| Incorrect MR description | Ensure it starts with a summary and ends with `Closes <JIRA TICKET ID>`. |
| Forgetting to pull main | Always run `git checkout main && git pull` before branching. |

## Red Flags - STOP and Correct
- **Failing to use Atlassian CLI `acli` for Jira operations.**
- **Creating any ticket or issue (Jira or GitLab).**
- Submitting an MR without the mandatory title prefix.
- **Creating an MR with a description that is not in Markdown format.**
- Forgetting to add the MR link as a Jira comment.
- Putting the implementation plan in a GitLab issue instead of a Jira comment.
- Implementing code before getting a Jira Ticket ID.
- Branching from an outdated `main`.
