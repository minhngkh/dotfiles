---
description: Generate a PR title/body from the current branch diff and create it in Azure DevOps
agent: gen-pr
---

Create an Azure DevOps pull request for the current branch.

- Target branch: `origin/dev` (override by passing a different target in `$ARGUMENTS`).
- Source branch: the current git branch.

## Steps

1. Make sure the target branch exists; fetch it if needed:
   ```bash
   git fetch origin dev
   ```

2. Capture the diff against the target branch:
   ```bash
   git --no-pager diff --numstat origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'
   git --no-pager diff -w --no-color origin/dev... -- ':!*lock*' ':!*.svg' ':!*.min.js'
   ```

3. Generate a concise PR title and description from the diff.

4. Use the `task` tool with `subagent_type` set to `azure-devops` to create the PR. Pass:
   - source branch: current branch name
   - target branch: `origin/dev` (or the branch from `$ARGUMENTS`)
   - Title: the generated title
   - Description: the generated description

5. Return the result from @azure-devops, including the PR URL/ID.

User arguments: $ARGUMENTS
