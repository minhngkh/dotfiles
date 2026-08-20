# Router Testing

Use Angular's real router configuration rather than mocking `Router`, `ActivatedRoute`, or other Angular router APIs. Fake application dependencies used by guards, resolvers, and routed components only when necessary.

Preserve the project's configured test runner and Zone.js or zoneless mode.

## RouterTestingHarness

`RouterTestingHarness` creates a root component with a `RouterOutlet` and reduces setup for routed components.

```ts
import {Component, inject} from '@angular/core';
import {TestBed} from '@angular/core/testing';
import {ActivatedRoute, provideRouter, Router} from '@angular/router';
import {RouterTestingHarness} from '@angular/router/testing';

@Component({
  template: '<h1>User Profile: {{ userId }}</h1>',
})
class UserProfile {
  private readonly route = inject(ActivatedRoute);
  readonly userId = this.route.snapshot.paramMap.get('id');
}

describe('UserProfile routing', () => {
  let harness: RouterTestingHarness;

  beforeEach(async () => {
    TestBed.configureTestingModule({
      providers: [
        provideRouter([{path: 'user/:id', component: UserProfile}]),
      ],
    });
    harness = await RouterTestingHarness.create();
  });

  it('reads route parameters', async () => {
    const component = await harness.navigateByUrl('/user/123', UserProfile);

    expect(component.userId).toBe('123');
    expect(harness.routeNativeElement?.textContent).toContain('User Profile: 123');
    expect(TestBed.inject(Router).url).toBe('/user/123');
  });
});
```

## API Guidance

- `RouterTestingHarness.create()` creates the harness without navigating.
- `RouterTestingHarness.create('/path')` creates it and performs that initial navigation.
- Create at most one harness per test. It requires TestBed teardown with `destroyAfterEach: true`, the normal default.
- `harness.navigateByUrl(url)` waits for navigation and returns the activated component or `null`.
- `harness.navigateByUrl(url, ComponentType)` also verifies the activated type.
- `harness.routeNativeElement` accesses the active routed component's native element.
- `harness.routeDebugElement` accesses its `DebugElement`.
- Retrieve the live router with `TestBed.inject(Router)`.
- `harness.detectChanges()` runs change detection on the harness fixture.

`RouterTestingHarness` does not expose `router` or `getHarness()` properties.

## Navigation Triggered By The UI

For a link, button, or component action, navigate to the source route, perform the interaction, and wait for the navigation it starts:

```ts
const dashboard = await harness.navigateByUrl('/', Dashboard);

dashboard.selectHero({id: 42, name: 'Test Hero'});
await harness.fixture.whenStable();

expect(TestBed.inject(Router).url).toBe('/heroes/42');
expect(harness.routeNativeElement?.textContent).toContain('Test Hero');
```

Await the navigation promise directly when the application API returns it. `navigateByUrl()` already waits for its own navigation; an additional `whenStable()` is only needed for separately triggered navigation or other asynchronous component work.

Use `RouterTestingHarness` for routed components, route parameters, guards, redirects, resolvers, and ordinary outlets. Create a custom host component for layouts such as named outlets that do not fit its single test outlet.

## Official Sources

- `https://angular.dev/guide/routing/testing`
- `https://angular.dev/api/router/testing/RouterTestingHarness`
