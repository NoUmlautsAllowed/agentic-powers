---
name: gitlab-workflow
description: Use when starting a new feature implementation, executing an implementation plan, or managing a GitLab issue and merge request lifecycle
---

# Feature Development Workflow

## Overview
This skill defines the standard workflow for developing new features, from issue creation to submitting a merge request. It ensures your local workspace is up to date and changes are systematically developed and reviewed.

## When to Use
- You have an approved implementation plan and need to start coding.
- You are creating a feature branch for a new task.
- You need to create a GitLab issue and a corresponding Merge Request for a planned feature.

## Core Pattern

### 1. Update Workspace
Always ensure your local repository is up to date before branching.
```bash
git checkout main
git pull
```

### 2. Create Issue
Create a GitLab issue to track the work. Use the plan as the description and add relevant labels.
```bash
glab issue create --title "[Feature Name]" --description "$(cat path/to/plan.md)"
```

### 3. Create Feature Branch
Checkout a new feature branch for your work.
```bash
git checkout -b feat/[feature-name]
```

### 4. Implement Plan
Execute the implementation plan systematically. If using subagents, dispatch them for specific tasks following Test-Driven Development (TDD).

### 5. Push and Create Merge Request
Once implementation is complete, tests pass, and your branch is updated, push and open a Merge Request.
**The MR description MUST be in Markdown format.**
- **The feature branch must ALWAYS be pushed to the remote with the `--set-upstream` (or `-u`) setting.**
- **The MR description MUST ALWAYS contain "Closes #ISSUE" if the MR references an issue.**

```bash
git push -u origin feat/[feature-name]
glab mr create --title "Implement [Feature Name]" --description "### Summary of changes
- [Brief list of changes]

Closes #[Issue Number]
"
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Branching from an outdated `main` branch | Always run `git checkout main && git pull` before creating a new feature branch. |
| Forgetting to link the issue in the MR | Append `Closes #<Issue Number>` to the MR description. **This is MANDATORY if the MR references an issue.** |
| Pushing without `--set-upstream` | Always use `git push -u origin <branch>` to set up remote tracking. |
| Pushing without running tests | Ensure all changes compile and pass tests before pushing. |
| Creating an MR with conflicts | Rebase or merge `main` into your feature branch before creating the MR. |
| Leaving merged branches in local | Run `git branch -d <branch>` after the MR is merged. |
| Non-Markdown MR description | Always use Markdown (headers, bullets) for MR descriptions. |

## Red Flags - STOP and Correct
- Creating a feature branch without pulling `main` first.
- Implementing a complex plan without decomposing it into test-driven steps.
- Creating an MR without a descriptive summary or issue link.
- **Pushing a feature branch WITHOUT the `--set-upstream` (or `-u`) setting.**
- **Creating an MR for an issue WITHOUT the `Closes #ISSUE` string in the description.**
- **Creating an MR with a description that is not in Markdown format.**
- Ignoring CI/CD pipeline failures after pushing.
