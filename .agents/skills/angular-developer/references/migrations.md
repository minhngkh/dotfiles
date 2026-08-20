# Automatic Migrations & Code Modernization

When a requested modernization has an official schematic in the installed Angular version, prefer it over manual text replacement. Review its diff before adding manual follow-up changes.

## Discovering Migrations

To view all available schematics for the installed version of the core framework, run:
`ng generate @angular/core: --help`

## Common Migration Schematics

Use the following commands to apply specific syntax updates. You can scope these commands to a specific project or directory using the `--project <name>` or `--path <dir>` flags.

| Feature to Modernize      | Command to Execute                                          |
| :------------------------ | :---------------------------------------------------------- |
| **Built-in Control Flow** | `ng generate @angular/core:control-flow`                    |
| **Signal-based Inputs**   | `ng generate @angular/core:signal-input-migration`          |
| **Signal Queries**        | `ng generate @angular/core:signal-queries-migration`        |
| **Functional Outputs**    | `ng generate @angular/core:output-migration`                |
| **`inject()` Function**   | `ng generate @angular/core:inject`                          |
| **Self-Closing Tags**     | `ng generate @angular/core:self-closing-tag`                |
| **Standalone**            | `ng generate @angular/core:standalone` (See workflow below) |

## Specialized Workflow: Migrating to Standalone

The Standalone migration is an interactive, three-stage refactoring. Verify the relevant tests and build after each stage:

1. **Phase 1**: Run `ng generate @angular/core:standalone` and select the option to **Convert all components, directives, and pipes to standalone**.
2. **Phase 2**: Verify the build with `ng build`. Run the command again and select **Remove unnecessary NgModule classes**.
3. **Phase 3**: Verify the build with `ng build`. Run the final pass and select **Bootstrap the project using standalone APIs**.
4. **Final verification**: Run the relevant tests and `ng build`, then review the complete migration diff.
