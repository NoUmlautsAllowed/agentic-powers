<div align="center">
  <h1>✨ Agentic Powers</h1>
  <p><strong>A collection of custom agents and skills for coding agents.</strong></p>
</div>

---

`agentic-powers` provides modular capabilities, specialized subagents, and domain-specific guidance to significantly enhance your AI-assisted development workflow with coding agents like Claude or Junie.

> 🙌 **Huge Shoutout:** A massive thanks to the amazing [obra/superpowers](https://github.com/obra/superpowers) repository! The subagents and skills in this project are heavily inspired by and adapted from their fantastic work.
>
> 🦴 **Caveman Skill Source:** The `caveman` skill is sourced from [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman).

## 📁 Project Structure

- 🤖 **`agents/`**: Configuration files for specialized subagents. These agents can be delegated specific tasks like code review or commit message generation.
- 🛠️ **`skills/`**: Modular skills that extend an agent's functionality with domain-specific guidance, scripts, and best practices.
- ⚙️ **`install`**: A bash script to link the agents and skills to the configuration directory (defaults to Junie).

## 🚀 Installation

To install the agents and skills, run the provided `install` script from the project root. By default, it will symlink the directories to `~/.junie`.

```bash
./install [target_directory]
```

- **Default Target:** `~/.junie`
- **Arguments:** You can optionally provide a custom target directory.

## 🤖 Agents

Agents are defined in Markdown files with YAML frontmatter. They provide instructions and personas for specialized tasks.

| Agent | Description |
|-------|-------------|
| 🕵️‍♂️ **`code-reviewer`** | Use this agent when a major project step has been completed and needs to be reviewed against the original plan and coding standards. |
| 📝 **`commit-assistant`** | Autonomously view and summarize changes to create a git commit with a great message. |
| 🛠️ **`implementer`** | Executes a well-defined implementation task. |
| 🧐 **`plan-reviewer`** | Reviews an implementation plan for completeness, spec alignment, and target architecture. |

## 🛠️ Skills

Each skill is located in its own directory within `skills/` and includes a `SKILL.md` file describing its usage.

| Skill | Description |
|-------|-------------|
| 🎫 **`acli-jira`** | Use when interacting with Jira using the acli CLI tool — creating, viewing, editing, searching, transitioning work items, managing sprints, boards, or projects via command line. |
| 🎫 **`atlassian-cli`** | Work seamlessly with Atlassian products (Jira, Confluence) from the command line using the `acli` tool. |
| 🦴 **`caveman`** | Ultra-compressed communication mode. Cuts token usage ~75% by speaking like caveman. |
| 🧠 **`brainstorming`** | You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation. |
| 📝 **`git-commit`** | Use when creating git commit messages to ensure they follow project standards and best practices. |
| 🦊 **`gitlab-workflow`** | Use when starting a new feature implementation, executing an implementation plan, or managing a GitLab issue and merge request lifecycle |
| 🦊 **`glab-cli`** | Manage GitLab issues, merge requests, CI/CD pipelines, and repositories using the GitLab CLI (glab). |
| 🎫 **`jira-workflow`** | Use when implementing features or bugfixes tracked in Jira, before starting code modifications, and when managing the GitLab Merge Request lifecycle. |
| 🤖 **`subagent-driven-development`** | Use when executing implementation plans with independent tasks in the current session |
| 🌳 **`using-git-worktrees`** | Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification |
| 📋 **`writing-plans`** | Use when implementing features or bugfixes that require multiple steps, before starting code modifications. |
| ✍️ **`writing-skills`** | Use when creating new skills, editing existing skills, or verifying skills work before deployment |

## 💡 Usage

Once installed, these agents and skills become automatically available to coding agents like Junie during the development process. 

📚 **Tip:** Refer to individual `SKILL.md` files within the `skills/` directory for specific usage instructions and best practices for each skill.

---
<div align="center">
  <i>Empowering autonomous development with AI coding agents.</i>
</div>
