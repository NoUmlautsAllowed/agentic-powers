---
name: glab-cli
description: Manage GitLab issues, merge requests, CI/CD pipelines, and repositories using the GitLab CLI (glab).
---

### GitLab CLI (glab) Skill Guidelines

This guide provides instructions and examples for using the `glab` CLI to manage GitLab resources efficiently. The `glab` binary is typically available in the system PATH.

#### 1. General Usage and Global Flags
All `glab` commands can be used with global flags to specify the target repository or host.
- `-R, --repo <OWNER/REPO>`: Select another repository using the `OWNER/REPO` or `GROUP/NAMESPACE/REPO` format or the project ID.
- `-h, --help`: Display help for a command.

Example:
```bash
glab repo view -R owner/project
```

#### 2. Authentication
Check your login status or specify a GitLab instance.
- **Check status:**
  ```bash
  glab auth status
  ```
- **Login to a specific instance:**
  ```bash
  glab auth login --hostname gitlab.example.com
  ```

#### 3. Managing Issues
When creating issues in non-interactive environments (like scripts or CI), both `--title` and `--description` are required.
- **List issues:**
  ```bash
  glab issue list -R owner/project
  ```
- **View an issue:**
  ```bash
  glab issue view <id> -R owner/project
  ```
- **Create an issue (Non-interactive):**
  ```bash
  glab issue create -R owner/project --title "Issue Title" --description "Detailed Description" --label emergency
  ```
- **Close an issue:**
  ```bash
  glab issue close <id> -R owner/project
  ```

#### 4. Managing Merge Requests (MRs)
- **List MRs:**
  ```bash
  glab mr list -R owner/project
  ```
- **View MR details and status:**
  ```bash
  glab mr view <id> -R owner/project
  ```
- **Create an MR:**
  ```bash
  glab mr create --fill --label bugfix -R owner/project
  ```
- **View MR diff:**
  ```bash
  glab mr diff <id> -R owner/project
  ```
- **Merge an MR:**
  ```bash
  glab mr merge <id> -R owner/project
  ```

#### 5. CI/CD Pipelines and Jobs
- **List pipelines:**
  ```bash
  glab ci list -R owner/project
  ```
- **View pipeline status:**
  ```bash
  glab ci status -R owner/project
  ```
- **Trace a job log:**
  ```bash
  glab ci trace <job-id> -R owner/project
  ```

#### 6. Repository Operations
- **Search for projects:**
  Use the `-s` flag to search by name or description.
  ```bash
  glab repo search -s "project"
  ```
- **View project details:**
  ```bash
  glab repo view owner/project
  ```
- **Clone a repository:**
  ```bash
  glab repo clone owner/project
  ```

#### 7. Practical Tips for Automation
- **Piping outputs:** Use standard Unix tools like `grep`, `awk`, or `jq` (if JSON output is supported via `--format json`) to parse outputs.
- **Specifying project IDs:** You can use the numeric project ID in place of the `OWNER/REPO` string for most commands.
- **Handling multiple hosts:** If you work with multiple GitLab instances, always use the full repository URL or specify the host via `GLAB_HOST` environment variable if needed.
- **Interactive vs. Non-interactive:** Always provide all required flags (like title and description for issue creation) to avoid interactive prompts that will fail in an automated environment.
