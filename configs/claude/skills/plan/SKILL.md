---
name: plan
description: Formalize feature requirements into specs and an implementation plan. Use when ready to convert a feature discussion into actionable specs.
---

# Plan Feature: $ARGUMENTS

Convert requirements into formal specs and an implementation plan.

If invoked after a prior discussion, build on that context. If invoked cold, spend extra time in the Clarify step.

## Process

1. **Clarify** — Confirm understanding of requirements. Use AskUserQuestion for any remaining gaps: scope boundaries, edge cases, tradeoffs, directories/packages that should NOT be touched. Do not proceed until requirements are clear.

2. **Explore** — Delegate to the Explore subagent to understand relevant codebase areas. Verify existing patterns and integration points. Never assume functionality doesn't exist.

3. **Write specs** — Write one spec per topic to `.specs/`. Each spec should be independently implementable.

Use this template:

```markdown
# {Topic Name}

## Context

Why this is needed. Background information. How it fits into the product.

## Functional Requirements

What the feature/system must DO. Bullet points. Specific behavior. No implementation details.

## Acceptance Criteria

Observable, testable criteria. Each must be unambiguous.

- [ ] Criterion (specific, measurable)

## Test Requirements

What tests should be written or updated.

## Implementation Notes (for executor)

<!-- Pointers to relevant files, patterns, and decisions. NOT implementation instructions — just context. -->
```

Quality guidelines:

- Functionally complete: No ambiguity about what "done" means
- Implementation-agnostic: Specify WHAT, not HOW
- Testable criteria: Every acceptance criterion is observable
- Appropriate scope: One topic per spec (the "one sentence without 'and'" test)
- Include test requirements: Specify what tests to write, not how
- Add implementation notes: Help the implementer find relevant patterns and files

4. **Review** — Present each spec to the user. Refine until approved. Do NOT proceed to plan generation until specs are confirmed.

5. **Generate plan** — Write `.specs/_plan.md`:

- If scope exclusions were identified, include a `## Out of Scope` section at the top
- Each task should represent one meaningful, atomic unit of work. Not too large to be unfocussed, not too small to waste a whole implementation cycle on
- Use `- [ ]` checkbox syntax
- Reference specs: `- Spec: name.md` on the line after each task
- Order by dependency, then priority

6. **Handoff** — Report: how many specs and tasks were created, recommended starting point, blockers or concerns.

## Guidelines

- **Don't assume not implemented** — verify with Explore
- **One task = one commit** — tasks should be atomic
- **Specs encode decisions** — everything the loop needs must be in the spec
- **Plan is disposable** — it can be regenerated from specs anytime
