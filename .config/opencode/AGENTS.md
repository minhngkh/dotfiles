## Global Agent Operating Rules

### Scope

- The main agent leads requirements, architecture, tradeoffs, and integration.
- Use workers to save time and tokens on idiomatic, repetitive, or well-defined work, including independent subtasks that benefit from parallel execution.
- Shape the approach and boundaries before handing off implementation; review and integrate worker results in the main session.

### Explore in proportion to scope

- Inspect known, bounded locations directly. For unfamiliar or wide-reaching work, use `explore` to build a map of the relevant code.
- Use `general` for focused investigation or documentation research when delegation saves effort.
- Reuse existing maps, sources, and child sessions; confirm the code being changed before editing.

### Multi-repo work

- For sequential implementation, use `session_move` once per repository-sized phase or when a worktree becomes the primary workspace; validate that phase before moving on.
- After moving, re-check destination instructions, conventions, and test commands before editing. Run destination-dependent tools only after the move takes effect, in a separate tool call.
- For parallel or large rollouts, keep a coordinating session and repo-specific workers with stable working directories and a shared change brief. For frequent cross-repo comparisons, use explicit paths rather than repeatedly moving.

### General: select effort

Select the exact `model` in each general dispatch:

- **Low** — lookups, routine research, and straightforward tasks: `github-copilot/gpt-6-luna#low`.
- **Xhigh** — coding, debugging, refactoring, and demanding analysis: `openai/gpt-6-luna#xhigh`.

Use these verified references directly; look up models only for a user-requested alternative or a rejected reference.

### Subagent handoff

Each dispatch includes the goal, scope, relevant file/source references, conditional skills to invoke, and a checkable done condition. Return findings or changed paths, sources or verification, and blockers; reference artifacts instead of duplicating them.

Pass well format handoff instructions directly in the subagent prompt for every dispatch, including relavant information, context, etc for it to work on effciently.

### Explorer output

Explore returns relevant paths and symbols, their flow, likely change points, existing checks, and unresolved gaps. Distinguish confirmed findings from hypotheses; stop when the requested map is complete.

## MUST FOLLOW RULES
- use a hard cutover approach and never implement backward compatibility unless specify
- if a function adds no value besides calling another function, then inline

## Agent skills

### Issue tracker

Issues are tracked as local markdown files under `.scratch/<feature>/` in the active project workspace. See `/home/gmi4hc/.config/opencode/docs/agents/issue-tracker.md`.

### Triage labels

The triage vocabulary uses the default canonical labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `/home/gmi4hc/.config/opencode/docs/agents/triage-labels.md`.

### Domain docs

The default domain layout is single-context: one `GLOSSARY.md` and `docs/adr/` at the active project root. See `/home/gmi4hc/.config/opencode/docs/agents/domain.md`.
