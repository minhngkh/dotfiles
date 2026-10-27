---
name: fabrik-ui
description: Use when working with, using, or changing Fabrik UI (`@fabrik/ui`).
---

# Fabrik UI

## How to use

1. **Locate the library.** If the current workspace is the Fabrik UI source checkout— it contains
   `projects/ui/package.json` or is the `projects/ui` project—use that source directly. Do not run
   link resolution. Otherwise, from the consumer workspace run:

   ```bash
   npm ls --link @fabrik/ui
   ```

   If npm reports a built path such as `./../web-ui/dist/ui`, use
   `./../web-ui/projects/ui` as the source by replacing the final `/dist/ui` with `/projects/ui`.
   Read and edit the source path, never generated `dist/ui`. If no link is reported, use the
   installed package for usage questions; ask for a source checkout before making library changes.
2. **Find what is available.** For usage questions with a source checkout, read its
   `docs/component-status.md` first to identify available components. Then check the library package
   metadata for versions and inspect `projects/ui/src/public-api.ts` plus the matching
   `projects/ui/src/lib/` directory. In a consumer without source, inspect the installed
   `@fabrik/ui` declarations. Treat public exports and declarations as authoritative for selectors,
   inputs, outputs, providers, and required parts.
3. **Read the matching Storybook story.** Source `*.stories.ts` files are the canonical usage
   examples. Use the relevant story for imports, markup, variants, forms, overlays, accessibility,
   and recipes before proposing code. Translate source-relative imports to `@fabrik/ui` imports in
   consumer code. Use a README only when no matching story covers the use case.
4. **Use the smallest suitable interface.** Prefer native modules, then simple compounds, compound
   parts, or a Storybook recipe. Import every standalone declaration used by the template. Query
   ng-primitives only when the Fabrik contract and story do not clarify behavior.

For usage answers, show the `@fabrik/ui` imports, Angular `imports`, template, and any required
provider or global style setup. Import `@fabrik/ui/styles.css` once globally, preserve native
attributes/events and accessible names, and call Angular bindings **inputs** and **outputs**.

## How to make changes

When the user asks to change Fabrik UI, edit the resolved source project—not `dist/ui`,
`node_modules`, or a consumer-side workaround. If the source checkout is not known, ask for it.

1. Read the source checkout's `CONTEXT.md`, `docs/component-patterns.md`, matching component
   directory, and Storybook story.
2. Add a supported variant and its story when a reusable option or state should coexist with the
   existing behavior. Edit the existing component, directive, template, or styles directly when the
   current variant or API should behave or look differently.
3. Export new public declarations from `projects/ui/src/public-api.ts`. Expose only stable Fabrik
   inputs and outputs; keep behavior, ARIA, focus, keyboard handling, state, and providers with
   ng-primitives.
4. Update the matching story and user-facing documentation when public usage changes. Verify the
   focused tests and the relevant format, lint, build, Storybook, and accessibility checks.

## Boundaries

- Prefer a public Fabrik API over `Ngp*`; Fabrik does not re-export upstream directives.
- Use `hostDirectives` and upstream state injectors for compound behavior instead of recreating it.
- Use semantic `--ui-*` tokens for visuals and preserve behavioral `data-*` and `--ngp-*` channels.
- Let one element own scrolling in virtualized overlays, and verify any Fabrik escape hatch before
  using it.
- Use one kebab-case custom-element selector for visual custom hosts, or a constrained attribute
  selector for native/semantic hosts. Apply changes as a hard cutover without compatibility
  aliases or duplicate selectors.

## Motion

For explicit Fabrik motion work, read only the matching standalone `transitions-dev` reference
(for example, [17-tooltip.md](../transitions-dev/17-tooltip.md)) as visual inspiration. Adapt its
transition declarations to the existing DOM and `data-*` / `--ngp-*` hooks; preserve upstream DOM,
behavior, state, ARIA, focus, and positioning, use semantic `--ui-*` visual tokens, and retain
reduced-motion behavior. Keep the implementation within the existing component rather than
importing standalone recipe markup or state machines.
