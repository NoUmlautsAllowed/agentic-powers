---
name: atlassian-cli
description: Work seamlessly with Atlassian products (Jira, Confluence) from the command line using the `acli` tool.
---

### Atlassian CLI (acli) Skill Guidelines

This guide provides instructions and examples for using the `acli` CLI to manage Atlassian resources. The `acli` binary is typically available in the system PATH.

#### 1. Authentication
Check your login status or authenticate to an Atlassian instance.
- **Authenticate:**
  ```bash
  acli auth login
  ```
- **Check status:**
  ```bash
  acli auth status
  ```

#### 2. Managing Jira Work Items
Jira work items (Issues) can be viewed, created, and updated using the `acli jira workitem` command.

- **View an Issue:**
  ```bash
  acli jira workitem view ISSUE-XXXX
  ```
  To see specific fields:
  ```bash
  acli jira workitem view ISSUE-XXXX --fields summary,description,status
  ```
  To get JSON output:
  ```bash
  acli jira workitem view ISSUE-XXXX --json
  ```

- **Comment on an Issue:**
  ```bash
  acli jira workitem comment create --key ISSUE-XXXX --body "This is a comment"
  ```
  Using a body file:
  ```bash
  acli jira workitem comment create --key ISSUE-XXXX --body-file comment.txt
  ```

- **Update Issue Status (Transition):**
  ```bash
  acli jira workitem transition ISSUE-XXXX "In Progress"
  ```

- **Assign an Issue:**
  ```bash
  acli jira workitem assign --key ISSUE-XXXX --assignee "user@example.com"
  ```

#### 3. Confluence Operations
Confluence pages and spaces can be managed using the `acli confluence` command.

- **View a Page:**
  ```bash
  acli confluence page view PAGE_ID
  ```

#### 4. Practical Tips
- **Non-interactive mode:** Ensure all required flags are provided to avoid interactive prompts.
- **Parsing output:** Use `jq` with the `--json` flag for automated processing.
- **JQL Search:** Use `--jql` for bulk operations or searching.
  ```bash
  acli jira workitem search --jql "project = PROJECT_KEY AND status = 'To Do'"
  ```
