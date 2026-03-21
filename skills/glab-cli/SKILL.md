---
name: glab-cli
description: Manage GitLab issues, merge requests, CI/CD pipelines, and repositories using the GitLab CLI (glab).
---

### GitLab CLI (glab) Skill Guidelines

This guide provides instructions and examples for using the `glab` CLI to manage GitLab resources. The `glab` binary is located at `glab`.

#### 1. General Usage
Always use the full path to the binary or ensure it is in your `PATH`.
```bash
/home/dev/bin/glab <command> <subcommand> [flags]
```

#### 2. Authentication
If not already authenticated, use:
```bash
glab auth login
```
To check status:
```bash
glab auth status
```

#### 3. Managing Issues
- **List issues:**
  ```bash
  glab issue list --repo <group/project>
  ```
- **View an issue:**
  ```bash
  glab issue view <id>
  ```
- **Create an issue:**
  ```bash
  glab issue create --title "Issue Title" --description "Issue Description"
  ```
- **Close an issue:**
  ```bash
  glab issue close <id>
  ```

#### 4. Managing Merge Requests (MRs)
- **List MRs:**
  ```bash
  glab mr list
  ```
- **Create an MR:**
  ```bash
  glab mr create --fill --label bugfix
  ```
- **View MR diff:**
  ```bash
  glab mr diff <id>
  ```
- **Merge an MR:**
  ```bash
  glab mr merge <id>
  ```

#### 5. CI/CD Pipelines and Jobs
- **List pipelines:**
  ```bash
  glab ci list
  ```
- **View pipeline status:**
  ```bash
  glab ci status
  ```
- **Trace a job log:**
  ```bash
  glab ci trace <job-id>
  ```
- **Run a manual job:**
  ```bash
  glab ci trigger <job-id>
  ```

#### 6. Repository Operations
- **Clone a repository:**
  ```bash
  glab repo clone <group/project>
  ```
- **Search for projects:**
  ```bash
  glab repo search <keyword>
  ```
- **View project details:**
  ```bash
  glab repo view <group/project>
  ```

#### 7. Tips
- Use `-R` or `--repo` to specify the repository if you are not inside a git repository or want to target another one.
  - Format: `group/project` or `https://gitlab.com/group/project`.
- **Handling multiple GitLab instances:**
  - If you are authenticated to multiple GitLab instances, `glab` might default to `gitlab.com`.
  - To specify a host for a command, use a full URL in the `--repo` flag, e.g., `glab repo view https://gitlab.example.com/owner/repo`.
- Use `--help` after any command or subcommand to see available flags and examples.
- Many commands support `--web` to open the resource in your browser.
