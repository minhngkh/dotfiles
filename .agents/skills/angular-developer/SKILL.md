---
name: angular-developer
description: Angular development. Use when building, modifying, debugging, testing, reviewing, or migrating Angular applications and libraries, including components, templates, directives, pipes, signals, forms, HTTP, dependency injection, routing, SSR, accessibility, styling, animations, and builds.
license: MIT
metadata:
  author: Copyright 2026 Google LLC
  version: '1.1'
---

# Angular Developer

## Workflow

1. **Load matching references.** Map the task to the routing rules below. Read
   the deduplicated matching set, resolving paths against this skill's base
   directory. Track loaded paths and reuse them; reread only when a file
   changed or the earlier read was incomplete. Complete this step when every
   matching reference is loaded and no unrelated reference is loaded.
2. **Implement in context.** Preserve project conventions and package versions.
   Make the smallest coherent change.
3. **Verify the scope.** Run the relevant tests and build. Fix failures caused
   by the change, and report pre-existing or unavailable checks.

Installed packages and project conventions override reference guidance. For
   conceptual guidance outside a workspace, state the assumed Angular version.

## Reference routing

Read [project-creation.md](references/project-creation.md) when scaffolding an
application or library.

### Components

For any component task, read [components.md](references/components.md). Add:

- Signal inputs, transforms, or model inputs → [inputs.md](references/inputs.md)
- Outputs or custom events → [outputs.md](references/outputs.md)
- Host bindings or attributes → [host-elements.md](references/host-elements.md)

For directives, projection, queries, lifecycle, or uncovered component topics,
use `https://angular.dev/guide/components` after checking the Angular version.

### Reactivity

Read only the references for the APIs or behavior involved. Preserve RxJS where
it models event streams or cancellation well.

- `signal`, `computed`, or `untracked` → [signals-overview.md](references/signals-overview.md)
- `linkedSignal` → [linked-signal.md](references/linked-signal.md)
- `resource` or async signal state → [resource.md](references/resource.md)
- `effect` or external synchronization → [effects.md](references/effects.md)

### HTTP

- `provideHttpClient`, `HttpClient`, interceptors, security, or HTTP testing → [http-client.md](references/http-client.md)
- `httpResource` → also [resource.md](references/resource.md)

### Forms

Choose the project's existing strategy. Prefer Signal Forms for suitable new
forms; for Angular 20 and earlier, use Reactive or template-driven forms.

- Signal Forms → [signal-forms.md](references/signal-forms.md)
- Template-driven forms → [template-driven-forms.md](references/template-driven-forms.md)
- Reactive forms → [reactive-forms.md](references/reactive-forms.md)

### Dependency injection

Always read [di-fundamentals.md](references/di-fundamentals.md). Add:

- Services or `providedIn` → [creating-services.md](references/creating-services.md)
- Providers, tokens, provider functions, or scopes → [defining-providers.md](references/defining-providers.md)
- `inject()` context APIs → [injection-context.md](references/injection-context.md)
- Injector hierarchy or resolution modifiers → [hierarchical-injectors.md](references/hierarchical-injectors.md)

### Pipes

Formatting values, creating pipes, or reusing pipe logic → [pipes.md](references/pipes.md).
Prefer template pipes; outside templates, use standalone formatting functions.

### Accessibility

- Semantics, names, keyboard/focus behavior, or verification → [accessibility.md](references/accessibility.md)
- Angular Aria controls → [angular-aria.md](references/angular-aria.md)
- Angular Aria with Signal Forms → both [angular-aria.md](references/angular-aria.md) and [signal-forms.md](references/signal-forms.md)

### Routing and rendering

Read only the references for the route feature involved:

- Paths, parameters, wildcards, or redirects → [define-routes.md](references/define-routes.md)
- Eager or lazy loading → [loading-strategies.md](references/loading-strategies.md)
- Router outlets → [show-routes-with-outlets.md](references/show-routes-with-outlets.md)
- `RouterLink`, `Router`, or navigation → [navigate-to-routes.md](references/navigate-to-routes.md)
- Guards → [route-guards.md](references/route-guards.md)
- `ResolveFn` or route pre-fetching → [data-resolvers.md](references/data-resolvers.md)
- Router events or lifecycle → [router-lifecycle.md](references/router-lifecycle.md)
- CSR, SSG, SSR, or hydration → [rendering-strategies.md](references/rendering-strategies.md)
- Route View Transitions → [route-animations.md](references/route-animations.md)

For uncovered routing topics, use `https://angular.dev/guide/routing` after
checking the Angular version.

### Styling and animations

- Tailwind CSS → [tailwind-css.md](references/tailwind-css.md)
- Element animations, `animate.enter`, `animate.leave`, or the legacy DSL → [angular-animations.md](references/angular-animations.md)
- Component styles or encapsulation → [component-styling.md](references/component-styling.md)

### Testing

For unit or component tests, always read [testing-fundamentals.md](references/testing-fundamentals.md). Add:

- Component harnesses → [component-harnesses.md](references/component-harnesses.md)
- Router navigation tests → [router-testing.md](references/router-testing.md)
- E2E tests → [e2e-testing.md](references/e2e-testing.md)

### Tooling

- CLI dependencies, serving, or building → [cli.md](references/cli.md)
- Migrations or modernization → [migrations.md](references/migrations.md)
- Build-time or runtime environment configuration → [environment-configuration.md](references/environment-configuration.md)
