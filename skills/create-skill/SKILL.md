---
name: create-skill
description: Guidelines and template for creating new Junie skills
---

# Create Skill

Use this skill when you need to create a new Junie skill to extend your capabilities with specialized instructions, resources, or scripts.

## Key Principles
- **Modularity**: Skills should be focused on a specific tool, framework, or workflow.
- **Consistency**: All skills must follow the standardized structure and naming conventions.
- **Actionability**: Include clear guidelines, examples, and checklists to make the skill immediately useful.
- **Documentation First**: Read the skill documentation before using its resources.

## Guidelines
- **Storage**: Skills must be stored in `~/.junie/skills/<skill-name>/SKILL.md`.
- **Naming**: The `name` in the frontmatter and the directory name must be identical.
- **Frontmatter**: Every `SKILL.md` must start with a YAML frontmatter containing `name` and `description`.
- **Structure**: Use the standard template including Purpose, Key Principles, Guidelines, Examples, and Checklist.
- **Supporting Files**: Place additional documentation, scripts, or checklists in subdirectories (e.g., `docs/`, `scripts/`, `checklists/`).

## Examples

### Skill Directory Structure
```text
~/.junie/skills/my-skill-name/
├── SKILL.md
├── checklists/
│   └── review.md
└── scripts/
    └── setup.sh
```

### Frontmatter Example
```markdown
---
name: my-skill-name
description: A short description of what this skill provides
---
```

## Checklist

### Skill Creation Checklist
- [ ] Directory created at `~/.junie/skills/<skill-name>/`
- [ ] `SKILL.md` file created with correct frontmatter
- [ ] Frontmatter `name` matches directory name
- [ ] Description is concise and clear
- [ ] Key Principles and Guidelines are defined
- [ ] Examples (structure or code) are provided
- [ ] Supporting files (if any) are correctly referenced
