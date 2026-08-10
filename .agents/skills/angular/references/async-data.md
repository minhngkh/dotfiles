# Async Data with HttpClient, RxJS, and Signals

For production Angular applications, prefer **`HttpClient` + RxJS** for async data flows.
Use the **`AsyncPipe`** in templates by default, and use **`toSignal()`** only when component logic needs signal-based consumption.

## Default Rules

1. Model server data as `Observable`s in services.
2. Prefer `AsyncPipe` in templates instead of manual subscriptions.
3. Use `toSignal()` at the component boundary when you need to compose async data with `computed()` or other signals.
4. Keep `effect()` for side effects, not primary data loading.
5. Avoid manual `subscribe()` in components unless the workflow is explicitly imperative (submit, navigate, download, fire-and-forget side effect).

## Service Pattern

Keep data fetching in services and return typed `Observable`s.

```ts
import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';

export interface User {
  id: string;
  name: string;
  email: string;
}

@Injectable({ providedIn: 'root' })
export class UsersApi {
  private readonly http = inject(HttpClient);

  getUser(id: string) {
    return this.http.get<User>(`/api/users/${id}`);
  }

  listUsers() {
    return this.http.get<User[]>('/api/users');
  }
}
```

## Template-First Consumption with `AsyncPipe`

Prefer exposing a view-model `Observable` and binding it with `AsyncPipe`.

```ts
import { Component, inject, input } from '@angular/core';
import { AsyncPipe } from '@angular/common';
import { catchError, map, of, startWith, switchMap } from 'rxjs';
import { toObservable } from '@angular/core/rxjs-interop';
import { UsersApi } from './users-api';

@Component({
  imports: [AsyncPipe],
  templateUrl: './user-profile.html',
})
export class UserProfile {
  private readonly api = inject(UsersApi);

  readonly userId = input.required<string>();

  readonly vm$ = toObservable(this.userId).pipe(
    switchMap((id) =>
      this.api.getUser(id).pipe(
        map((user) => ({ status: 'ready' as const, user, error: '' })),
        startWith({ status: 'loading' as const, user: null, error: '' }),
        catchError(() =>
          of({ status: 'error' as const, user: null, error: 'Unable to load user' }),
        ),
      ),
    ),
  );
}
```

```html
@if (vm$ | async; as vm) { @switch (vm.status) { @case ('loading') {
<p>Loading…</p>
} @case ('error') {
<p>{{ vm.error }}</p>
} @default {
<h2>{{ vm.user!.name }}</h2>
<p>{{ vm.user!.email }}</p>
} } }
```

## Signal Consumption with `toSignal()`

Use `toSignal()` when the component needs synchronous reads in TypeScript or when async data must feed `computed()` state.

```ts
import { Component, computed, inject, input } from '@angular/core';
import { toObservable, toSignal } from '@angular/core/rxjs-interop';
import { switchMap } from 'rxjs';
import { UsersApi } from './users-api';

@Component({ template: `{{ displayName() }}` })
export class UserBadge {
  private readonly api = inject(UsersApi);

  readonly userId = input.required<string>();

  private readonly user$ = toObservable(this.userId).pipe(switchMap((id) => this.api.getUser(id)));

  readonly user = toSignal(this.user$, { initialValue: undefined });

  readonly displayName = computed(() => this.user()?.name ?? 'Loading…');
}
```

## Loading, Error, and Refresh Patterns

- Build a small view-model stream with `map`, `startWith`, and `catchError`.
- Use `switchMap` for request-by-input flows.
- Use `shareReplay({bufferSize: 1, refCount: true})` when multiple consumers should reuse one request.
- Trigger refreshes with a dedicated `Subject`/signal input and re-run the pipeline with `switchMap`.

## Avoid These Patterns

- Loading primary server data in `effect()`
- Nesting subscriptions
- Manual subscription management for template-only reads
- Pushing HTTP results into mutable component fields when an `Observable` or signal adapter would be clearer
