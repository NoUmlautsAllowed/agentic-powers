---
name: git-commit
description: Use when creating git commit messages to ensure they follow project standards and best practices.
---

# Git Commit Standard

## Overview
This skill defines the standard for creating high-quality Git commit messages within this project. Following these rules ensures a clean, readable, and searchable project history.

## The Seven Rules of a Great Git Commit Message

1.  **Separate subject from body with a blank line**
2.  **Limit the subject line to 50 characters**
3.  **Capitalize the subject line**
4.  **Do not end the subject line with a period**
5.  **Use the imperative mood in the subject line** (e.g., "Fix bug" not "Fixed bug")
6.  **Wrap the body at 72 characters**
7.  **Use the body to explain what and why vs. how**

## Commit Message Template

```text
Summarize changes in around 50 characters or less

Explain the problem that this commit is solving. Focus on why you
are making this change as opposed to how (the code explains that).
Are there side effects or other consequences? Here's the place to
explain them.

Further paragraphs come after blank lines.

 - Bullet points are okay, too
 - Typically a hyphen or asterisk is used for the bullet

Resolves: #123
See also: #456, #789
```

## When to Use
-   Every time you are about to run `git commit`.
-   When drafting a PR description (often mirrors the commit body).
-   When a subagent (like `commit-assistant`) is tasked with committing changes.
