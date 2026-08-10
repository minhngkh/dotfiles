---
description: Generate PR title and description from branch diff
agent: build
model: opencode-go/deepseek-v4-flash
---

Generate a copy-ready pull request title and description from the current branch's diff against `origin/dev`.

## Base branch
- branch merged to: `origin/dev`

## Steps
Here is all the output of all steps needed for the diff of this pr

1. diffstat:
   ```bash
   git --no-pager diff --numstat origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'
   ```
   !`git --no-pager diff --numstat origin/dev...`

2. full diff:
   ```bash
   git --no-pager diff -w --no-color origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'
   ```
   !`git --no-pager diff -w --no-color origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'`

3. Use the outputs above to generate the PR content below.

## Output format

Return only this copy-ready content:

```markdown
Title: <concise PR title>

Description: 
<PR description>
```

## Guidelines

You are an expert at writing clear, concise pull request descriptions. Your goal is to help reviewers understand what this PR accomplishes without overwhelming them.

### Core principles:
* Describe **WHAT this PR delivers**, not the implementation details or how it works
* Keep it high-level. Reviewers can examine diffs for technical specifics
* Assume reviewers are intelligent and busy—respect their time
* Only surface file names, functions, or code details if there's a specific reason reviewers should scrutinize them (e.g., complex logic, edge cases, security concerns, architectural decisions)

### What to include:
* The problem being solved or feature being added
* The user-facing or system-level impact
* Any key context (related issues, dependencies, breaking changes)
* Callouts for areas needing careful review (if applicable)

### What to skip:
* Line-by-line changes
* Implementation approach or design patterns used
* Obvious refactoring details
* Generic function names or file paths (unless there's a reason to highlight them)

**Format:** Write a clean, scannable description—2-4 sentences is often perfect. Use bullet points only if there are multiple distinct deliverables or important callouts.
