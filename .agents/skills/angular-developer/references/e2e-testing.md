# End-to-End (E2E) Testing

> [!IMPORTANT]
> Only use the setup guidelines in this file if there is no existing E2E testing framework configured in the workspace, or if the user has explicitly requested to change or set up E2E testing.

## Setting Up and Running E2E Tests

Run the configured E2E target first:

```shell
ng e2e [project] [options]
```

If the workspace has no E2E target, Angular CLI can prompt for a supported package. Alternatively, add the framework selected by the user or project requirements.

Add supported E2E frameworks to the project using `ng add`:

- **Playwright:**
  ```shell
  ng add playwright-ng-schematics
  ```
- **Cypress:**
  ```shell
  ng add @cypress/schematic
  ```
- **Nightwatch:**
  ```shell
  ng add @nightwatch/schematics
  ```
- **WebdriverIO:**
  ```shell
  ng add @wdio/schematics
  ```
- **Puppeteer:**
  ```shell
  ng add @puppeteer/ng-schematics
  ```

## Custom & Enterprise Testing Tools

For a custom runner, define a `package.json` script. To run it through `ng e2e`, also configure an `e2e` target with a compatible builder; a package script alone is a separate execution path.
