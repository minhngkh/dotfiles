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

1. **Inspect the workspace.** Before choosing APIs or giving version-sensitive guidance, read `package.json`, `angular.json` when present, and nearby code. Identify the Angular and Angular CLI major versions, package manager, standalone or NgModule conventions, form strategy, test runner, and whether the application uses Zone.js. The inspection is complete when every version-sensitive choice in the task can be tied to installed packages or an explicit new-project target.
2. **Load the matching references.** Before planning or editing, map the task to every matching branch below and read each linked reference. Overlapping tasks require all matching references. For example, a routed component test requires both testing fundamentals and router testing. Installed package APIs, project configuration, and existing conventions take precedence when a reference describes a different version.
3. **Implement in context.** Preserve established naming, architecture, and package versions unless the task is an explicit migration. Edit the smallest coherent set of files directly, following the workspace's conventions.
4. **Verify the changed scope.** After code changes, run the most relevant tests and the build for the affected application or library. Fix failures introduced by the change. Report pre-existing failures, unavailable commands, and checks that could not run rather than expanding the task to unrelated repairs.

For conceptual guidance outside a workspace, state the Angular version assumed whenever the answer depends on it.

## Creating New Projects

Read [project-creation.md](references/project-creation.md) when scaffolding a new application or library.

## Components

For component work, read every matching reference:

- **Fundamentals**: Anatomy, metadata, core concepts, and template control flow (@if, @for, @switch). Read [components.md](references/components.md)
- **Inputs**: Signal-based inputs, transforms, and model inputs. Read [inputs.md](references/inputs.md)
- **Outputs**: Signal-based outputs and custom event best practices. Read [outputs.md](references/outputs.md)
- **Host Elements**: Host bindings and attribute injection. Read [host-elements.md](references/host-elements.md)

For directives, content projection, queries, lifecycle, or other component topics not covered locally, use the matching guide at `https://angular.dev/guide/components` after inspecting the installed Angular version.

## Reactivity and Data Management

For reactive state, read every matching reference. Preserve RxJS where it already models event streams or cancellation well; do not migrate it merely because signals are available.

- **Signals Overview**: Core signal concepts (`signal`, `computed`), reactive contexts, and `untracked`. Read [signals-overview.md](references/signals-overview.md)
- **Dependent State (`linkedSignal`)**: Creating writable state linked to source signals. Read [linked-signal.md](references/linked-signal.md)
- **Async Reactivity (`resource`)**: Fetching asynchronous data into signal state. Read [resource.md](references/resource.md)
- **Side Effects (`effect`)**: External synchronization, third-party DOM integration, and render effects. Read [effects.md](references/effects.md)

## HTTP Communication

For `HttpClient`, interceptors, HTTP security, or HTTP testing setup, read:

- **HTTP Client and Resources**: `provideHttpClient`, `HttpClient`, interceptors, and `httpResource`. Read [http-client.md](references/http-client.md)

For `httpResource`, also read [resource.md](references/resource.md).

## Forms

Choose the form API from the installed Angular version and the surrounding feature:

- Prefer Signal Forms for new forms when they fit the project; preserve an established Reactive or template-driven forms strategy for existing features.
- For Angular 20 and earlier, use Reactive or template-driven forms.

- **Signal Forms**: Model-driven signal state for new forms. Read [signal-forms.md](references/signal-forms.md)
- **Template-driven forms**: Existing or simple forms centered on template directives. Read [template-driven-forms.md](references/template-driven-forms.md)
- **Reactive forms**: Existing form models and complex imperative control composition. Read [reactive-forms.md](references/reactive-forms.md)

## Dependency Injection

For dependency injection, read every matching reference:

- **Fundamentals**: Overview of Dependency Injection, services, and the `inject()` function. Read [di-fundamentals.md](references/di-fundamentals.md)
- **Creating and Using Services**: Creating services, the `providedIn: 'root'` option, and injecting into components or other services. Read [creating-services.md](references/creating-services.md)
- **Defining Dependency Providers**: Automatic vs manual provision, `InjectionToken`, `useClass`, `useValue`, `useFactory`, and scopes. Read [defining-providers.md](references/defining-providers.md)
- **Injection Context**: Where `inject()` is allowed, `runInInjectionContext`, and `assertInInjectionContext`. Read [injection-context.md](references/injection-context.md)
- **Hierarchical Injectors**: The `EnvironmentInjector` vs `ElementInjector`, resolution rules, modifiers (`optional`, `skipSelf`), and `providers` vs `viewProviders`. Read [hierarchical-injectors.md](references/hierarchical-injectors.md)

## Pipes

When formatting values in templates, creating custom pipes, or reusing pipe-like logic in TypeScript, consult the following reference. Prefer pipes in templates; outside templates, avoid injecting pipe classes just to call `transform()`.

- **Pipes**: Built-in pipe imports, custom pipe naming and implementation, pure vs impure pipes, and TypeScript reuse patterns using standalone formatting functions or extracted plain functions. Read [pipes.md](references/pipes.md)

## Accessibility And Angular Aria

- **Accessibility Fundamentals**: Semantic HTML, accessible names, keyboard and focus behavior, and verification. Read [accessibility.md](references/accessibility.md)
- **Angular Aria Components**: Headless custom Accordion, Listbox, Combobox, Menu, Tabs, Toolbar, Tree, and Grid patterns. Read [angular-aria.md](references/angular-aria.md)

For an Angular Aria control bound with Signal Forms, read both [angular-aria.md](references/angular-aria.md) and [signal-forms.md](references/signal-forms.md).

## Routing

For routing or rendering work (CSR, SSG, SSR), read every matching reference:

- **Define Routes**: URL paths, static vs dynamic segments, wildcards, and redirects. Read [define-routes.md](references/define-routes.md)
- **Route Loading Strategies**: Eager vs lazy loading, and context-aware loading. Read [loading-strategies.md](references/loading-strategies.md)
- **Show Routes with Outlets**: Using `<router-outlet>`, nested outlets, and named outlets. Read [show-routes-with-outlets.md](references/show-routes-with-outlets.md)
- **Navigate to Routes**: Declarative navigation with `RouterLink` and programmatic navigation with `Router`. Read [navigate-to-routes.md](references/navigate-to-routes.md)
- **Control Route Access with Guards**: Implementing `CanActivate`, `CanMatch`, and other guards for security. Read [route-guards.md](references/route-guards.md)
- **Data Resolvers**: Pre-fetching data before route activation with `ResolveFn`. Read [data-resolvers.md](references/data-resolvers.md)
- **Router Lifecycle and Events**: Chronological order of navigation events and debugging. Read [router-lifecycle.md](references/router-lifecycle.md)
- **Rendering Strategies**: CSR, SSG (Prerendering), and SSR with hydration. Read [rendering-strategies.md](references/rendering-strategies.md)
- **Route Transition Animations**: Enabling and customizing the View Transitions API. Read [route-animations.md](references/route-animations.md)

For route state, custom matching, reuse, or other routing topics not covered locally, use the matching guide at `https://angular.dev/guide/routing`.

## Styling and Animations

For styling and animations, read every matching reference:

- **Using Tailwind CSS with Angular**: Integrating Tailwind CSS into Angular projects. Read [tailwind-css.md](references/tailwind-css.md)
- **Element Animations**: Native CSS, `animate.enter` and `animate.leave`, or the legacy DSL. Read [angular-animations.md](references/angular-animations.md)
- **Styling components**: Best practices for component styles and encapsulation. Read [component-styling.md](references/component-styling.md)

Route View Transitions use [route-animations.md](references/route-animations.md), not the element animation reference.

## Testing

For unit and component tests, always read testing fundamentals, then read each specialized reference that matches:

- **Fundamentals**: Existing test-runner detection, async patterns, and `TestBed`. Read [testing-fundamentals.md](references/testing-fundamentals.md)
- **Component Harnesses**: Standard patterns for robust component interaction. Read [component-harnesses.md](references/component-harnesses.md)
- **Router Testing**: Using `RouterTestingHarness` for reliable navigation tests. Read [router-testing.md](references/router-testing.md)
- **End-to-End (E2E) Testing**: Preserve, configure, and run the workspace's E2E framework. Read [e2e-testing.md](references/e2e-testing.md)

## Tooling

For tooling, read every matching reference:

- **Angular CLI**: Managing dependencies, serving, and building. Read [cli.md](references/cli.md)
- **Code Modernization**: Automatically refactoring to modern standards using migrations. Read [migrations.md](references/migrations.md)
- **Environment Configuration**: Strategies for build-time and runtime configuration. Read [environment-configuration.md](references/environment-configuration.md)
