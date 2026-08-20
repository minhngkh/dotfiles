# Testing Fundamentals

Use Angular's testing utilities with the test runner and change-detection mode already configured by the project.

## Preserve Project Configuration

Before changing tests, inspect `angular.json`, package dependencies, test setup files, and nearby specs.

- Existing projects may be configured with Karma/Jasmine, Vitest, or another runner.
- Keep the existing runner, matchers, spies, mocks, and fake-timer APIs unless the task is an explicit migration.
- Keep the existing Zone.js or zoneless setup. Do not add or remove `zone.js`, `zone.js/testing`, `provideZoneChangeDetection()`, or `provideZonelessChangeDetection()` incidentally.
- `TestBed` uses Zone-based change detection when Zone.js is loaded by test polyfills. Without Zone.js, it runs zoneless by default.

Prefer native `async` and `await` for asynchronous tests. Use `fakeAsync`, runner-specific fake timers, or runner-specific mocking APIs only when the project is configured for them.

## TestBed And ComponentFixture

`TestBed` configures an Angular test environment. Use `imports` for standalone dependencies, `providers` for injected dependencies, and `declarations` only for non-standalone declarations. Configuration is optional when the component needs no additional setup.

`TestBed.createComponent()` returns a `ComponentFixture`:

- `fixture.componentInstance` accesses the component instance.
- `fixture.nativeElement` accesses the root native element.
- `fixture.debugElement` provides Angular-aware queries and access to the element injector.
- `fixture.componentRef.setInput()` updates an input through Angular.

Configure `TestBed` before the first call to `createComponent()` in a test.

## Rendering And Asynchronous Work

`TestBed.createComponent()` does not synchronously complete initial data binding.

Use `await fixture.whenStable()` when Angular scheduled rendering or other asynchronous work. In zoneless tests, update state through a change-notifying API such as a template-read signal, `componentRef.setInput()`, a bound event, `AsyncPipe`, or `ChangeDetectorRef.markForCheck()`.

`fixture.detectChanges()` remains supported and is useful when a test intentionally needs an immediate change-detection cycle. Prefer scheduled application-like updates when possible, but preserve existing suites that consistently use manual change detection.

When changing a native form control, set its value and dispatch the corresponding DOM event so Angular observes the change.

## Example

```ts
import {Component, signal} from '@angular/core';
import {ComponentFixture, TestBed} from '@angular/core/testing';

@Component({
  template: '<h1>{{ title() }}</h1>',
})
class TestComponent {
  readonly title = signal('Default Title');
}

describe('TestComponent', () => {
  let fixture: ComponentFixture<TestComponent>;
  let component: TestComponent;
  let heading: HTMLHeadingElement;

  beforeEach(() => {
    fixture = TestBed.createComponent(TestComponent);
    component = fixture.componentInstance;
    heading = fixture.nativeElement.querySelector('h1');
  });

  it('displays the initial title', async () => {
    await fixture.whenStable();
    expect(heading.textContent).toContain('Default Title');
  });

  it('updates the displayed title', async () => {
    component.title.set('New Title');
    await fixture.whenStable();
    expect(heading.textContent).toContain('New Title');
  });
});
```

Use the assertion and mocking syntax already configured in the project.

## Official Sources

- `https://angular.dev/guide/testing`
- `https://angular.dev/guide/testing/components-basics`
- `https://angular.dev/guide/zoneless#testing-and-debugging`
