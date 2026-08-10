---
description: Generate PR title and description from branch diff
agent: build
model: opencode-go/deepseek-v4-flash
---

Generate a copy-ready pull request title and description from the embedded git diff context below.

## Base branch
- branch merged to: `origin/dev`

!`echo 'fuck you'`
!`echo "$(pwd)"`

## Diffstat

!`git --no-pager diff --numstat origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'`

## Full diff

!`git --no-pager diff -w --no-color origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'`

## Output format

Return only this copy-ready content:

```markdown
Title: <concise PR title>

Description:
## Summary
- <bullet>
- <bullet>
- <bullet if useful>

## Notice points
- <bullet of things that need notice or is risk>
```

## Guidelines

- Focus on the user-facing or reviewer-relevant intent of the changes.
- Use concise language throughout.
- Prefer short bullet points over long sentences or paragraphs.
- Optimize the description for reviewers: make scope, intent, risk, and verification easy to grasp quickly.
- Mention important behavior changes, migrations, config changes, or risks when present.
- Do not include raw diff output in the final answer.
- Do not commit, stage, push, or modify files.

User arguments: $ARGUMENTS
