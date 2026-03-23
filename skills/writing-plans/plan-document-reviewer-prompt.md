# Plan Reviewer Prompt Template

Use this template when dispatching a plan-reviewer subagent.

**Purpose:** Verify the plan is complete, matches the spec, and aligns with the target architecture.

Dispatch after: The complete plan is written.

```
Agent tool:
  agent: "plan-reviewer"
  task: |
    Review this plan document for completeness, spec alignment, and architectural integrity.

    **Plan to review:** [PLAN_FILE_PATH]
    **Spec for reference:** [SPEC_FILE_PATH]

    ## What to Check

    | Category | What to Look For |
    |----------|------------------|
    | Spec Alignment | Plan covers all requirements from the spec, no scope creep |
    | Architecture | Plan follows the target architecture and design patterns in spec |
    | Completeness | No TODOs, placeholders, or missing critical implementation steps |
    | Task Decomposition | Tasks are bite-sized, test-driven (TDD), and actionable |
    | File Structure | Organization matches the architectural intent |

    ## Calibration

    **Only flag issues that would cause real problems during implementation or architectural drift.**
    An implementer building the wrong thing, ignoring the architecture, or getting stuck is an issue.
    Minor wording or "nice to have" stylistic suggestions are not.

    Approve unless there are serious gaps — missing requirements, architectural violations,
    contradictory steps, placeholder content, or tasks so vague they can't be acted on.
```

**Reviewer returns:** Status, Issues (if any), Recommendations
