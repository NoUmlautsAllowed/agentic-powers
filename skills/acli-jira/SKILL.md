---
name: acli-jira
description: Use when interacting with Jira using the acli CLI tool — creating, viewing, editing, searching, transitioning work items, managing sprints, boards, or projects via command line.
---

# acli Jira CLI Reference

## Overview

The `acli` CLI tool provides Jira Cloud command-line access. All Jira operations use the `acli jira` prefix. **Work items (issues) use the `workitem` subcommand — NOT `issue`.**

## Auth

```bash
acli auth login       # Authenticate
acli auth status      # Check current auth
```

## Work Items (Issues)

The subcommand is `workitem`, never `issue`.

### View

```bash
acli jira workitem view KEY-123
acli jira workitem view KEY-123 --json                        # JSON output
acli jira workitem view KEY-123 --fields "*all"               # All fields
acli jira workitem view KEY-123 --fields "summary,status,assignee,description"
acli jira workitem view KEY-123 --web                         # Open in browser
```

### Search (JQL)

```bash
acli jira workitem search --jql "project = PROJ AND status = 'To Do'"
acli jira workitem search --jql "project = PROJ AND assignee = currentUser()" --paginate   # All pages
acli jira workitem search --jql "project = PROJ" --json
acli jira workitem search --jql "project = PROJ" --csv                  # CSV output
acli jira workitem search --jql "project = PROJ" --fields "key,summary,assignee,status"
acli jira workitem search --jql "project = PROJ" --limit 50
acli jira workitem search --jql "project = PROJ" --count                # Count only
```

### Create

```bash
acli jira workitem create --summary "Fix login bug" --project PROJ --type Bug
acli jira workitem create --summary "New feature" --project PROJ --type Story \
  --assignee "@me" --label "frontend,urgent"
acli jira workitem create --summary "Sub-task" --project PROJ --type Task \
  --parent PROJ-100
acli jira workitem create --from-file workitem.txt --project PROJ --type Bug
acli jira workitem create --generate-json                               # Generate JSON template
acli jira workitem create --from-json workitem.json
```

### Edit

```bash
acli jira workitem edit --key PROJ-123 --summary "Updated title"
acli jira workitem edit --key PROJ-123 --labels "urgent" --yes          # --yes skips confirmation
acli jira workitem edit --key "PROJ-1,PROJ-2" --assignee "user@example.com" --yes
acli jira workitem edit --jql "project = PROJ AND status = 'To Do'" --labels "backlog" --yes
```

### Transition (Status Change)

```bash
acli jira workitem transition --key PROJ-123 --status "In Progress"
acli jira workitem transition --key "PROJ-1,PROJ-2" --status "Done" --yes
acli jira workitem transition --jql "project = PROJ AND assignee = currentUser()" --status "In Review" --yes
```

**Status name must match exactly** the transition name in the Jira workflow (case-sensitive).

### Assign

```bash
acli jira workitem assign --key PROJ-123 --assignee "@me"               # Self-assign
acli jira workitem assign --key PROJ-123 --assignee "user@example.com"
acli jira workitem assign --key PROJ-123 --assignee "default"           # Project default
acli jira workitem assign --key PROJ-123 --remove-assignee
acli jira workitem assign --jql "project = PROJ" --assignee "@me" --yes
```

### Comments

```bash
acli jira workitem comment create --key PROJ-123 --body "Comment text"
acli jira workitem comment create --key PROJ-123 --body-file comment.txt
acli jira workitem comment list --key PROJ-123
acli jira workitem comment update --key PROJ-123 --comment-id 10001 --body "Updated"
acli jira workitem comment delete --key PROJ-123 --comment-id 10001
```

### Other Work Item Operations

```bash
acli jira workitem clone --key PROJ-123                                 # Duplicate
acli jira workitem delete --key PROJ-123 --yes
acli jira workitem archive --key PROJ-123
acli jira workitem link ...                                             # Link work items
acli jira workitem attachment ...                                       # Manage attachments
```

## Projects

```bash
acli jira project list
acli jira project view PROJ
acli jira project create --name "My Project" --key PROJ --type software
acli jira project update --key PROJ --name "New Name"
acli jira project archive --key PROJ
acli jira project delete --key PROJ
```

## Sprints

```bash
acli jira sprint view SPRINT_ID
acli jira sprint create --name "Sprint 1" --board BOARD_ID
acli jira sprint update --id SPRINT_ID --name "Sprint 2"
acli jira sprint list-workitems --id SPRINT_ID
acli jira sprint delete --id SPRINT_ID
```

## Boards

```bash
acli jira board search                                                   # List boards
acli jira board get BOARD_ID
acli jira board list-sprints BOARD_ID                                   # All sprints on board
acli jira board list-projects BOARD_ID
acli jira board create --name "My Board" --type scrum --project PROJ
```

## Common Flags

| Flag | Meaning |
|------|---------|
| `--json` | JSON output (not `--output json`) |
| `--csv` | CSV output (search only) |
| `--yes` / `-y` | Skip confirmation prompt |
| `--paginate` | Fetch all pages (not `--all`) |
| `--jql` | JQL query string |
| `--web` | Open in browser |
| `--fields` | Comma-separated field list |
| `--assignee "@me"` | Self-assign (not `me` or `currentUser()`) |

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `acli jira issue view KEY-1` | Use `acli jira workitem view KEY-1` |
| `--output json` | Use `--json` |
| `--all` for pagination | Use `--paginate` |
| `--to "In Progress"` for transition | Use `--status "In Progress"` |
| `--assignee me` | Use `--assignee "@me"` |
| `--body @file.txt` for comment file | Use `--body-file file.txt` |
| `--no-confirm` | Use `--yes` or `-y` |
| `acli jira workitem transition KEY-1 "Done"` (positional) | Use `--key KEY-1 --status "Done"` |
