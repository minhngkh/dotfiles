# Angular CLI Guide for Agents

Use the workspace-local Angular CLI for dependency management, serving, and building. Inspect `angular.json`, `package.json`, and existing files first because CLI behavior follows the installed version.

## Managing Dependencies

Use `ng add` when a package provides an `ng-add` schematic; otherwise use the project's configured package manager. For version-coupled `@angular/*` packages, select the major compatible with the workspace instead of upgrading Angular implicitly.

```bash
ng add @angular/material@<angular-major>
ng add tailwindcss
ng add @angular/fire
```

Run `ng update` only when an update was requested. It changes package versions and runs applicable migrations:

```bash
ng update @angular/cli @angular/core
ng update @angular/cli@^22 @angular/core@^22
```

## Development Server And Proxying

Start the local development server with hot-module replacement (HMR):

```bash
ng serve
```

### Backend API Proxying

To proxy API requests during development (e.g., rerouting `/api` to a local Node server):

1. Create `src/proxy.conf.json`:
   ```json
   {
     "/api/**": {"target": "http://localhost:3000", "secure": false}
   }
   ```
2. Update `angular.json` under the `serve` target:
   ```json
   "serve": {
     "builder": "@angular/build:dev-server",
     "options": { "proxyConfig": "src/proxy.conf.json" }
   }
   ```

## Building the Application

Compile the application into an output directory (default: `dist/<project-name>/browser`). Modern Angular uses the `@angular/build:application` builder (esbuild-based).

```bash
ng build
```

- `ng build` defaults to the production configuration, which enables Ahead-of-Time (AOT) compilation, minification, and tree-shaking.
- Target specific configurations defined in `angular.json` using `--configuration`: `ng build --configuration=staging`.

## Testing

- **Unit Tests**: Run `ng test` to execute unit tests via the configured test runner (e.g., Karma or Vitest).
- **End-to-End (E2E)**: Run `ng e2e`. If no E2E framework is configured, the CLI will prompt to install one (Cypress, Playwright, Puppeteer, etc.).

## Deployment

To deploy an application, you must first add a deployment builder, then run the deploy command:

```bash
# Example for Firebase
ng add @angular/fire
ng deploy
```
