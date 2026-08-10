## MUST FOLLOW RULES
- use a hard cutover approach and never implement backward compatibility unless specify
- if a function adds no value besides calling another function, then inline 

## Agent skills

### Issue tracker

Issues are tracked as local markdown files under `.scratch/<feature>/` in the active project workspace. See `/home/gmi4hc/.config/opencode/docs/agents/issue-tracker.md`.

### Triage labels

The triage vocabulary uses the default canonical labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, and `wontfix`. See `/home/gmi4hc/.config/opencode/docs/agents/triage-labels.md`.

### Domain docs

This repo is configured as single-context. Skills should look for one root `CONTEXT.md` and root `docs/adr/`. See `/home/gmi4hc/.config/opencode/docs/agents/domain.md`.
