### Agentic Powers

`agentic-powers` is a collection of custom agents and skills for Junie, an autonomous programmer developed by JetBrains. This repository provides modular capabilities and specialized subagents to enhance the development workflow.

### Project Structure

- `agents/`: Contains configuration files for specialized subagents. These agents can be delegated specific tasks like code review or commit message generation.
- `skills/`: Contains modular skills that extend Junie's functionality with domain-specific guidance, scripts, and best practices.
- `install`: A bash script to link the agents and skills to Junie's configuration directory.

### Installation

To install the agents and skills, run the provided `install` script from the project root. By default, it will symlink the directories to `~/.junie`.

```bash
./install [target_directory]
```

- **Default Target:** `~/.junie`
- **Arguments:** You can optionally provide a custom target directory.

### Agents

Agents are defined in Markdown files with YAML frontmatter. They provide instructions and personas for specialized tasks.

- **`code-reviewer`**: A senior code reviewer agent that analyzes completed project steps against plans and coding standards.
- **`commit-assistant`**: (Managed by the repository) Helps in creating informative git commit messages.

### Skills

Each skill is located in its own directory within `skills/` and includes a `SKILL.md` file describing its usage.

- **`glab-cli`**: Manage GitLab resources using the `glab` CLI.
- **`brainstorming`**: Guidance for exploring intent and requirements before implementation.
- **`writing-plans`**: Best practices for creating multi-step implementation plans.
- **`writing-skills`**: Instructions and templates for creating and verifying new skills.
- **`create-skill`**: Standardized workflow for adding new capabilities to this repository.

### Usage

Once installed, these agents and skills become available to Junie during the development process. You can refer to individual `SKILL.md` files for specific usage instructions of each skill.
