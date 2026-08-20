# Router Lifecycle and Events

Angular Router emits events through the `Router.events` observable, allowing you to track the navigation lifecycle from start to finish.

## Common Router Events

1. **`NavigationStart`**: Navigation begins.
2. **`RoutesRecognized`**: Router matches the URL to a route.
3. **`GuardsCheckStart` / `End`**: Evaluation of `canActivate`, `canMatch`, etc.
4. **`ResolveStart` / `End`**: Data resolution phase (fetching data via resolvers).
5. Navigation finishes with one terminal outcome: `NavigationEnd` on success, `NavigationCancel` when canceled, or `NavigationError` when it fails.

## Subscribing to Events

Inject the `Router` and filter the `events` observable.

```ts
import {Injectable, inject} from '@angular/core';
import {NavigationEnd, Router} from '@angular/router';
import {filter} from 'rxjs';

@Injectable({providedIn: 'root'})
export class MyService {
  private router = inject(Router);

  constructor() {
    this.router.events.pipe(filter((e) => e instanceof NavigationEnd)).subscribe((event) => {
      console.log('Navigated to:', event.url);
    });
  }
}
```

## Debugging

Enable detailed console logging of all routing events during application bootstrap.

```ts
provideRouter(routes, withDebugTracing());
```

## Common Use Cases

- **Loading Indicators**: Show a spinner on `NavigationStart` and hide it on any terminal outcome.
- **Analytics**: Track page views by listening for `NavigationEnd`.
- **Scroll Management**: Respond to `Scroll` events for custom scroll behavior.
