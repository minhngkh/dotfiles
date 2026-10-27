---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the user's spec or tickets directly in the current context. Record the starting commit and any existing changes as the review baseline.

Use /tdd where possible, at pre-agreed seams, and run available typechecks and focused tests regularly, then the full suite at the end. If checks are absent, report manual verification; add test infrastructure only when agreed.

Once implementation is ready, invoke `code-review` with the baseline, spec, and changed paths, including uncommitted work. Apply fixes in this context, rerun checks, and re-review affected changes until findings are resolved or explicitly accepted.

After review, commit only this task's changes to the current branch unless the user asked to leave them uncommitted.
