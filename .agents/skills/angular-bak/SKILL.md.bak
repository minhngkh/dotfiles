---
name: angular
description: Use when a task is in an Angular project and touches Angular code, APIs, patterns, or framework behavior. Angular 21 expert guidance for components, services, signals, forms, DI, routing, SSR, accessibility, styling, testing, and CLI tooling. Avoid for purely generic TypeScript, CSS, HTML, or architecture tasks where Angular does not affect the answer.
---

# Angular Developer Guidelines

## Angular reference-read rule

Use this skill when the task is in an Angular project and touches Angular code, APIs, patterns, or framework behavior.

Do not invoke this skill for purely generic TypeScript, JavaScript, CSS, HTML, or architecture work just because the repository happens to be Angular. If Angular affects the implementation, conventions, build, tests, accessibility approach, styling encapsulation, or runtime behavior, invoke this skill.

Read the relevant Markdown files in this skill's `references/` folder before giving Angular-specific advice, planning Angular-specific changes, or editing Angular code.

Avoid repeatedly re-reading the same reference files every turn. If the relevant references were already read earlier in the same session and the task is the same Angular topic, rely on the already-loaded guidance. Re-read references when the topic changes, the previous read is no longer in context, uncertainty remains, or version-sensitive behavior is involved.

Minimum required behavior:

1. Identify which Angular topic areas the task touches.
2. Read the referenced `references/*.md` files needed for those topic areas, unless those same references were already read earlier in the same session for the same topic.
3. Only then answer, plan, or modify code.
4. If the task spans multiple Angular areas, read all relevant reference files across those areas.

Examples:

- Component inputs? Read `references/components.md` and `references/inputs.md`.
- Loading API/server data? Read `references/async-data.md`; if state is derived or retained, also read `references/signals-overview.md` and `references/linked-signal.md`.
- Forms? Read the matching forms reference first.
- Routing? Read the relevant routing references first.
- Tests? Read the relevant testing references first.
- Unsure which area applies? Read the closest matching references first, then proceed.

1. The project is in Angular 21, so provide guidance based on this version, as best practices and available features is different from previous versions.

2. When generating code, follow Angular's style guide and best practices for maintainability and performance. Use the Angular CLI for scaffolding components, services, directives, pipes, and routes to ensure consistency.

3. Once you finish generating code, run `ng build` to ensure there are no build errors. If there are errors, analyze the error messages and fix them before proceeding. Do not skip this step, as it is critical for ensuring the generated code is correct and functional.

## Components

When working with Angular components, consult the following references based on the task:

- **Fundamentals**: Anatomy, metadata, core concepts, and template control flow (@if, @for, @switch). Read [components.md](references/components.md)
- **Inputs**: Signal-based inputs, transforms, and model inputs. Read [inputs.md](references/inputs.md)
- **Outputs**: Signal-based outputs and custom event best practices. Read [outputs.md](references/outputs.md)
- **Host Elements**: Host bindings and attribute injection. Read [host-elements.md](references/host-elements.md)

If you require deeper documentation not found in the references above, read the documentation at `https://angular.dev/guide/components`.

## Reactivity and Data Management

When managing state and data reactivity, use Angular Signals for local UI state and use HttpClient + RxJS for async data. Consult the following references:

- **Signals Overview**: Core signal concepts (`signal`, `computed`), reactive contexts, and `untracked`. Read [signals-overview.md](references/signals-overview.md)
- **Dependent State (`linkedSignal`)**: Creating writable state linked to source signals. Read [linked-signal.md](references/linked-signal.md)
- **Async Data**: Fetching and shaping server data with HttpClient, RxJS, `AsyncPipe`, and `toSignal` when needed. Read [async-data.md](references/async-data.md)
- **Side Effects (`effect`)**: Logging, third-party DOM manipulation (`afterRenderEffect`), and when NOT to use effects. Read [effects.md](references/effects.md)

## Forms

In most cases for new apps, **prefer typed reactive forms**. When making a forms decision, analyze the project and consider the following guidelines:

- If this is a new or non-trivial form, **prefer typed reactive forms**.
- For older applications or when working with existing forms, use the appropriate form type that matches the application's current form strategy unless the user explicitly asks to migrate it.
- Use template-driven forms only for simple forms with minimal validation and little shared logic.

- **Reactive forms**: Use typed reactive forms for complex, dynamic, validated, reusable, or multi-step forms. Read [reactive-forms.md](references/reactive-forms.md)
- **Template-driven forms**: Use for small, simple forms. Read [template-driven-forms.md](references/template-driven-forms.md)

## Dependency Injection

When implementing dependency injection in Angular, follow these guidelines:

- **Fundamentals**: Overview of Dependency Injection, services, and the `inject()` function. Read [di-fundamentals.md](references/di-fundamentals.md)
- **Creating and Using Services**: Creating services, the `providedIn: 'root'` option, and injecting into components or other services. Read [creating-services.md](references/creating-services.md)
- **Defining Dependency Providers**: Automatic vs manual provision, `InjectionToken`, `useClass`, `useValue`, `useFactory`, and scopes. Read [defining-providers.md](references/defining-providers.md)
- **Injection Context**: Where `inject()` is allowed, `runInInjectionContext`, and `assertInInjectionContext`. Read [injection-context.md](references/injection-context.md)
- **Hierarchical Injectors**: The `EnvironmentInjector` vs `ElementInjector`, resolution rules, modifiers (`optional`, `skipSelf`), and `providers` vs `viewProviders`. Read [hierarchical-injectors.md](references/hierarchical-injectors.md)

## Angular Aria

When building accessible custom components for any of the following patterns: Accordion, Listbox, Combobox, Menu, Tabs, Toolbar, Tree, Grid, consult the following reference:

- **Angular Aria Components**: Building headless, accessible components (Accordion, Listbox, Combobox, Menu, Tabs, Toolbar, Tree, Grid) and styling ARIA attributes. Read [angular-aria.md](references/angular-aria.md)

## Routing

When implementing navigation in Angular, consult the following references:

- **Define Routes**: URL paths, static vs dynamic segments, wildcards, and redirects. Read [define-routes.md](references/define-routes.md)
- **Route Loading Strategies**: Eager vs lazy loading, and context-aware loading. Read [loading-strategies.md](references/loading-strategies.md)
- **Show Routes with Outlets**: Using `<router-outlet>`, nested outlets, and named outlets. Read [show-routes-with-outlets.md](references/show-routes-with-outlets.md)
- **Navigate to Routes**: Declarative navigation with `RouterLink` and programmatic navigation with `Router`. Read [navigate-to-routes.md](references/navigate-to-routes.md)
- **Control Route Access with Guards**: Implementing `CanActivate`, `CanMatch`, and other guards for security. Read [route-guards.md](references/route-guards.md)
- **Data Resolvers**: Pre-fetching data before route activation with `ResolveFn`. Read [data-resolvers.md](references/data-resolvers.md)
- **Router Lifecycle and Events**: Chronological order of navigation events and debugging. Read [router-lifecycle.md](references/router-lifecycle.md)
- **Rendering Strategies**: CSR, SSG (Prerendering), and SSR with hydration. Read [rendering-strategies.md](references/rendering-strategies.md)
- **Route Transition Animations**: Stable page motion patterns with native CSS and Angular's built-in animation bindings. Read [route-animations.md](references/route-animations.md)

If you require deeper documentation or more context, visit the [official Angular Routing guide](https://angular.dev/guide/routing).

## Styling and Animations

When implementing styling and animations in Angular, consult the following references:

- **Using Tailwind CSS with Angular**: Integrating Tailwind CSS into Angular projects. Read [tailwind-css.md](references/tailwind-css.md)
- **Angular Animations**: Using native CSS (recommended) or the legacy DSL for dynamic effects. Read [angular-animations.md](references/angular-animations.md)
- **Styling components**: Best practices for component styles and encapsulation. Read [component-styling.md](references/component-styling.md)

## Testing

When writing or updating tests, consult the following references based on the task:

- **Fundamentals**: Best practices for unit testing (Vitest), async patterns, and `TestBed`. Read [testing-fundamentals.md](references/testing-fundamentals.md)
- **Component Harnesses**: Standard patterns for robust component interaction. Read [component-harnesses.md](references/component-harnesses.md)
- **Router Testing**: Using `RouterTestingHarness` for reliable navigation tests. Read [router-testing.md](references/router-testing.md)
- **End-to-End (E2E) Testing**: Best practices for E2E tests with Cypress. Read [e2e-testing.md](references/e2e-testing.md)
