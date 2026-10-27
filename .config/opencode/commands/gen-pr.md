---
description: Generate PR title and description from branch diff
---

Generate a copy-ready pull request title and description from the current branch's diff against "!`echo -n "${$ARGUMENTS:-origin/dev}"`".

## Base branch
- branch merged to: "!`echo -n "${$ARGUMENTS:-origin/dev}"`"

## Steps
Here is all the output of all steps needed for the diff of this pr

1. diffstat:
   ```bash
   git --no-pager diff --numstat !`echo -n "${$ARGUMENTS:-origin/dev}"`... -- ':!*lock*' ':!*.svg' ':!*.min.js'
   ```
!`git --no-pager diff --numstat ${$ARGUMENTS:-origin/dev}... -- ':!*lock*' ':!*.svg' ':!*.min.js'`

2. full diff:
   ```bash
   git --no-pager diff -w --no-color !`echo -n "${$ARGUMENTS:-origin/dev}"`... -- ':!*lock*' ':!*.svg' ':!*.min.js'
   ```
!`git --no-pager diff -w --no-color ${$ARGUMENTS:-origin/dev}... -- ':!*lock*' ':!*.svg' ':!*.min.js'`

3. Use the outputs above to generate the PR content below.

## Title

Use Conventional Commits — the PR title usually becomes the squash-merge commit subject:

```
<type>(<optional scope>): <imperative summary>
```

* Pick `type` from what the diff predominantly is: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `build`, `ci`, `chore`
* Use `!` after the type (e.g. `feat!:`) when the PR contains breaking changes
* Add `(scope)` only when one obvious module or component name applies
* Summary: lowercase, imperative mood ("add", not "added"), no trailing period, aim for ≤ 72 characters
* The summary describes the deliverable, not the mechanism: `feat: rate-limit login attempts`, not `feat: add token-bucket utility`

## Visual enrichment (show-me skill)

Load the show-me skill (id: `show-me`) and use its judgment to decide whether this PR gets one visual, and which form. These PR-specific constraints override the skill where they conflict:

* Only GitHub-renderable output: Mermaid fenced blocks, plain fenced code blocks (pseudocode, call trees, component trees, file trees), or fenced `diff` blocks. Never write or open an HTML artifact — the output is PR text, not an interactive session.
* At most one visual, placed after the prose description.
* Include it only when the change has structure prose can't carry cheaply: cross-module data/control flow, UI component structure, or a broad refactor that moves responsibilities between files.
* Skip it entirely when prose already tells the story (localized change, config/docs-only). Don't force one.
* The visual shows the shape of the change — boundaries, order, flow — never line-level detail. It replaces prose on those points, it doesn't duplicate it.

Fit-for-purpose defaults from the skill: call tree for control-flow changes, component tree for UI changes, file tree for broad refactors, Mermaid sequence diagram for cross-component interactions, `diff` block for structural reshuffles.

## Output format

Return only this copy-ready content:

```markdown
Title: <type>(<scope>): <imperative summary>

Description: 
<PR description>

<one show-me visual if it adds value, otherwise omit>
```

## Guidelines

You are an expert at writing clear, concise pull request descriptions. Your goal is to help reviewers understand what this PR accomplishes without overwhelming them.

### Core principles:
* Describe **WHAT this PR delivers**, not the implementation details or how it works
* Keep it high-level. Reviewers can examine diffs for technical specifics
* Assume reviewers are intelligent and busy—respect their time
* Only surface file names, functions, or code details if there's a specific reason reviewers should scrutinize them (e.g., complex logic, edge cases, security concerns, architectural decisions) — or when distilled into the single show-me visual, which shows the shape of the change instead of its details

### What to include:
* The problem being solved or feature being added
* The user-facing or system-level impact
* Any key context (related issues, dependencies, breaking changes)
* Callouts for areas needing careful review (if applicable)

### What to skip (prose; the show-me visual is the exception):
* Line-by-line changes
* Implementation approach or design patterns used
* Obvious refactoring details
* Generic function names or file paths (unless there's a reason to highlight them)
* Anything the visual already shows at a glance, when one is included

**Format:** Write a clean, scannable description—2-4 sentences is often perfect. Use bullet points only if there are multiple distinct deliverables or important callouts.
