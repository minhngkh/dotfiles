---
name: code-review
description: "Review changes since a fixed point along two axes: Standards (does the code follow documented coding standards?) and Spec (does it match the originating issue/spec?). Use when the user wants to review a branch, PR, work-in-progress changes, or asks to \"review since X\"."
---

Two-axis review of committed or work-in-progress changes against a supplied fixed point:

- **Standards**: does the code conform to this repo's documented coding standards?
- **Spec**: does the code faithfully implement the originating issue / spec?

The same reviewer handles both axes in separate passes, then reports their findings side by side.

The issue tracker should have been provided to you. If not, tell the user to run `/setup-matt-pocock-skills`.

## Process

### 1. Pin the fixed point

Use the supplied fixed point (a commit SHA, branch name, tag, `main`, `HEAD~5`, etc.). If none was supplied, ask for it.

Capture the scope once. For committed work, use `git diff <fixed-point>...HEAD`. For work-in-progress, resolve `git merge-base <fixed-point> HEAD` and use `git diff <merge-base>` to include staged and unstaged changes. Include task-owned untracked files from `git ls-files --others --exclude-standard` by reading them separately. Note commits via `git log <fixed-point>..HEAD --oneline` and exclude unrelated pre-existing changes.

Before reviewing, confirm the fixed point resolves (`git rev-parse <fixed-point>`) and the review scope contains changes, including any task-owned untracked files. A bad ref or empty scope should fail here.

### 2. Identify the spec source

Look for the originating spec, in this order:

1. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.), fetched via the workflow in the tracker doc.
2. A path the user passed as an argument.
3. A spec file under `docs/`, `specs/`, or `.scratch/` matching the branch name or feature.
4. If nothing is found, ask the user where the spec is. If they say there isn't one, skip the Spec pass and report "no spec available".

### 3. Identify the standards sources

Search the repo for every file that documents how code should be written. When `CODING_STANDARDS.md` or `CONTRIBUTING.md` exists, it must be on the list.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below: a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation. Like any standard here, skip anything tooling already enforces.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name**: a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code**: the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy**: a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps**: the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession**: a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches**: the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery**: one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change**: one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality**: abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains**: long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man**: a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest**: a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Review both axes

Review the same captured scope yourself in two distinct passes. Do not spawn sub-agents.

**Standards pass:** Compare the changes with every standards source found in step 3 and the smell baseline above. Report documented-standard violations with the source file and rule. Report baseline smells as judgement calls, name the smell, and quote the relevant hunk. The repo's documented standards override the baseline. Skip anything tooling enforces. Keep this section under 400 words.

**Spec pass:** Compare the changes with the identified spec. Report missing or partial requirements, scope creep, and requirements that appear implemented incorrectly. Quote the spec line for each finding. If no spec is available, skip this pass and report that no spec was available. Keep this section under 400 words.

### 5. Aggregate

Present the two reports under `## Standards` and `## Spec` headings. Do **not** merge or rerank findings, because the two axes are deliberately separate (see _Why two axes_).

End with a one-line summary: total findings per axis, and the worst issue _within each axis_ (if any). Don't pick a single winner across axes: that's the reranking the separation exists to prevent.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.
