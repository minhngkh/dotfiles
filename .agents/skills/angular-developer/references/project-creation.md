# Creating New Projects

Use the requested Angular version when one is specified:

```bash
npx @angular/cli@<requested-version> new <project-name>
```

Otherwise create the project with the latest stable CLI, independent of any stale global installation:

```bash
npx @angular/cli@latest new <project-name>
```

After creation, run `ng version` inside the workspace and confirm the generated Angular major matches the requested version or current stable release. For form choices, apply the rules in the Forms section of `SKILL.md` and read the selected forms reference.