# Rendering Strategies

Angular supports multiple rendering strategies to optimize for SEO, performance, and interactivity.

## Client-Side Rendering (CSR)

**Default Strategy.** Content is rendered entirely in the browser.

- **Use case**: Interactive dashboards, internal tools.
- **Pros**: Simplest to configure, low server cost.
- **Cons**: Poor SEO, slower initial content visibility (must wait for JS).

## Static Site Generation (SSG / Prerendering)

Content is pre-rendered into static HTML files at **build time**.

- **Use case**: Marketing pages, blogs, documentation.
- **Pros**: Fastest initial load, excellent SEO, CDN-friendly.
- **Cons**: Requires rebuild for content updates, not for user-specific data.

## Server-Side Rendering (SSR)

Content is rendered on the server for the **initial request**. Subsequent navigations happen client-side (SPA style).

- **Use case**: E-commerce product pages, news sites, personalized dynamic content.
- **Pros**: Excellent SEO, fast initial content visibility.
- **Cons**: Requires a rendering runtime, with higher operational cost and latency than static hosting. `@angular/ssr` supports Web `Request` and `Response` runtimes; only `@angular/ssr/node` is Node-specific.

## Adding SSR

For an existing compatible workspace, add Angular's SSR package with the installed CLI:

```bash
ng add @angular/ssr
```

Modern Angular applications can choose a render mode per server route:

```ts
import {RenderMode, ServerRoute} from '@angular/ssr';

export const serverRoutes: ServerRoute[] = [
  {path: 'products/:id', renderMode: RenderMode.Server},
  {path: 'about', renderMode: RenderMode.Prerender},
  {path: '**', renderMode: RenderMode.Client},
];
```

Keep browser-only APIs such as `window`, `document`, `localStorage`, and layout measurement behind a browser check or a client-only boundary. Prefer Angular abstractions and server-compatible data access where possible.

## Hydration

Hydration is the process of making server-rendered HTML interactive in the browser.

- **Full Hydration**: The entire app becomes interactive at once.
- **Incremental Hydration**: (Advanced) Parts become interactive as needed using `@defer` blocks.
- **Event Replay**: Captures and replays user events that happened before hydration finished.

Use the hydration providers generated or already configured by the workspace. Inspect the installed Angular version before adding options such as incremental hydration or event replay.

## Verification

Run the configured build and server or preview target. Check rendered HTML without client JavaScript, watch for hydration mismatch warnings, and verify that server requests do not access browser-only globals.

## Decision Matrix

| Requirement                     | Strategy             |
| :------------------------------ | :------------------- |
| **SEO + Static Content**        | SSG                  |
| **SEO + Dynamic Content**       | SSR                  |
| **No SEO + High Interactivity** | CSR                  |
| **Mixed**                       | Hybrid (Route-based) |
