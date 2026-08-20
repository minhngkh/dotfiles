# Testing with Component Harnesses

Component harnesses provide a stable, user-oriented testing API for shared UI widgets and component libraries. Use a component's supported harness when one exists; direct DOM interaction remains appropriate for application-specific markup.

## Why Use Harnesses?

- **Robustness:** Tests don't break when you refactor a component's internal HTML or CSS classes.
- **Readability:** Tests describe interactions from a user's perspective (e.g., `button.click()`, `slider.getValue()`) instead of through DOM queries (`fixture.nativeElement.querySelector(...)`).
- **Reusability:** A harness implementation can run in multiple environments when an adapter exists. The CDK includes TestBed and Selenium WebDriver environments.

Angular Material provides a test harness for every component in its library.

## Using a Harness in a Unit Test

The `TestbedHarnessEnvironment` is the entry point for using harnesses in unit tests.

### Example: Testing with a `MatButtonHarness`

```ts
import {ComponentFixture, TestBed} from '@angular/core/testing';
import {HarnessLoader} from '@angular/cdk/testing';
import {TestbedHarnessEnvironment} from '@angular/cdk/testing/testbed';
import {MatButtonHarness} from '@angular/material/button/testing';
import {MyButtonContainerComponent} from './my-button-container.component';

describe('MyButtonContainerComponent', () => {
  let fixture: ComponentFixture<MyButtonContainerComponent>;
  let loader: HarnessLoader;

  beforeEach(() => {
    TestBed.configureTestingModule({});

    fixture = TestBed.createComponent(MyButtonContainerComponent);
    // Create a harness loader for the component's fixture
    loader = TestbedHarnessEnvironment.loader(fixture);
  });

  it('should find a button with specific text', async () => {
    // Load the harness for a MatButton with the text "Submit"
    const submitButton = await loader.getHarness(MatButtonHarness.with({text: 'Submit'}));

    // Use the harness API to interact with the component
    expect(await submitButton.isDisabled()).toBe(false);
    await submitButton.click();

    // ... assertions
  });
});
```

### Key Concepts

1.  **`HarnessLoader`**: An object used to find and create harness instances. Get a loader for your component's fixture using `TestbedHarnessEnvironment.loader(fixture)`.

2.  **`loader.getHarness(HarnessClass)`**: Asynchronously finds and returns a harness instance for the first matching component.

3.  **`HarnessClass.with({ ... })`**: Many harnesses provide a static `with` method that returns a `HarnessPredicate`. Use it when a query needs to filter by text, selector, state, or another supported property.

4.  **Harness API:** Harness methods are asynchronous. TestBed harnesses run change detection around reads and interactions; waiting for work outside Angular depends on the environment and test setup.

Use `TestbedHarnessEnvironment.documentRootLoader(fixture)` for overlay content attached to `document.body`. Use `harnessForFixture()` when testing a harness rooted at the fixture host itself.
