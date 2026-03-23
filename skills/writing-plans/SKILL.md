---
name: writing-plans
description: Use when implementing features or bugfixes that require multiple steps, before starting code modifications.
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`
- (User preferences for plan location override this default)

<HARD-GATE>
Do NOT start implementation or invoke any implementation skill (e.g., subagent-driven-development, executing-plans) until:
1. The plan is saved to a file.
2. The Plan Review Loop with a subagent is complete.
3. The user has reviewed the plan file and explicitly approved proceeding to implementation.
</HARD-GATE>

## Checklist

You MUST complete these items in order:

1. **Map File Structure** — Identify files to be created or modified.
2. **Decompose Tasks** — Break the work into bite-sized, test-driven steps.
3. **Write Plan to File** — Save the complete plan to the designated Markdown file.
4. **Plan Review Loop** — Dispatch a subagent to review the plan file.
5. **User Review Gate** — Ask the user to review the plan file and approve implementation.
6. **Execution Handoff** — Offer execution options once approved.

## Scope Check

If the spec covers multiple independent subsystems, it should have been broken into sub-project specs during brainstorming. If it wasn't, suggest breaking this into separate plans — one per subsystem. Each plan should produce working, testable software on its own.

## File Structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for. This is where decomposition decisions get locked in.

- Design units with clear boundaries and well-defined interfaces. Each file should have one clear responsibility.
- You reason best about code you can hold in context at once, and your edits are more reliable when files are focused. Prefer smaller, focused files over large ones that do too much.
- Files that change together should live together. Split by responsibility, not by technical layer.
- In existing codebases, follow established patterns. If the codebase uses large files, don't unilaterally restructure - but if a file you're modifying has grown unwieldy, including a split in the plan is reasonable.

This structure informs the task decomposition. Each task should produce self-contained changes that make sense independently.

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

- [ ] **Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

- [ ] **Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

- [ ] **Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

- [ ] **Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## Common Mistakes

- **Starting implementation too early** — Implementing before the plan is saved to a file, reviewed, and approved by the user.
- **Vague tasks** — Not specifying exact file paths or code changes.
- **Lack of testing steps** — Omitting the RED (test-first) and GREEN (minimal code) steps for each task.
- **Narrative over structure** — Including your session history or thought process in the plan instead of just technical implementation details.

## Rationalization Table

| Excuse | Reality |
|--------|---------|
| "The plan is simple enough for the chat output." | Chat history is truncated. Files persist. Implementation without a saved plan file violates the <HARD-GATE>. |
| "I'll save the plan after I finish the first task." | This creates a gap in the implementation history and violates the requirement for user approval. |
| "A subagent review is overkill for this feature." | Subagents identify gaps and edge cases that are often overlooked. All plans MUST be reviewed. |
| "The user already approved the design doc, so I can skip the plan review." | A design doc is NOT an implementation plan. The specific file-level steps must be reviewed and approved. |

## Red Flags - STOP and Save Plan

- You are about to use `search_replace` or `multi_edit` on source code without a saved plan file.
- You are invoking `subagent-driven-development` or `executing-plans` before the user has said "approved" or "proceed" to the written plan.
- The plan file is missing exact file paths or command lines.

**All of these mean: STOP. Write the plan to a file, complete the review loop, and get user approval.**

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Use `superpowers:subagent-driven-development` (or `superpowers:executing-plans`) for execution.
- DRY, YAGNI, TDD, frequent commits

## Plan Review Loop

After saving the plan file:

1. Dispatch a single plan-reviewer subagent (see agents/plan-reviewer.md) with precisely crafted review context — never your session history. This keeps the reviewer focused on the plan, not your thought process.
   - Provide: path to the plan document, path to spec document
2. If ❌ Issues Found: fix the issues in the file, re-dispatch reviewer for the whole plan
3. If ✅ Approved: proceed to User Review Gate

## User Review Gate

After the subagent review passes, ask the user to review the written plan before proceeding:

> "Plan written and saved to `<path>`. Please review it and let me know if you want to make any changes before we start implementation."

Wait for the user's response. If they request changes, make them in the file and re-run the plan review loop. Only proceed to Execution Handoff once the user approves.

## Execution Handoff

After the user approves the plan, offer execution choice:

**"Plan complete and saved to `docs/superpowers/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (recommended)** - I dispatch a fresh subagent per task, review between tasks, fast iteration

**2. Inline Execution** - Execute tasks in this session using executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Fresh subagent per task + two-stage review

**If Inline Execution chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:executing-plans
- Batch execution with checkpoints for review
