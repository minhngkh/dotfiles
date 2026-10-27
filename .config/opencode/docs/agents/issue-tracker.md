# Issue tracker: Local Markdown

This harness stores its agent skill configuration in `/home/gmi4hc/.config/opencode/docs/agents/`.

Issues and PRDs live as markdown files in the active project workspace.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The PRD is `.scratch/<feature-slug>/PRD.md`
- Implementation issues are `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01`
- Triage state is recorded as a `Status:` line near the top of each issue file (see `/home/gmi4hc/.config/opencode/docs/agents/triage-labels.md` for the role strings)
- Comments and conversation history append to the bottom of the file under a `## Comments` heading

## When a skill says "publish to the issue tracker"

Create a new file under the active project's `.scratch/<feature-slug>/` directory, creating directories as needed.

## When a skill says "fetch the relevant ticket"

Read the file at the referenced path. The user will normally pass the path or the issue number directly.
