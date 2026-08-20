# Route Loading Strategies

Angular supports two main strategies for loading routes and components to balance initial load time and navigation responsiveness.

## Eager Loading

Components are bundled into the initial JavaScript payload and are available immediately.

```ts
{ path: 'home', component: Home }
```

- **Pros**: Seamless transitions.
- **Cons**: Increases initial bundle size.

## Lazy Loading

Components or routes are split into separate JavaScript chunks loaded on demand or by a configured preloading strategy.

### Lazy Loading Components

Use `loadComponent` to fetch the component on demand.

```ts
{
  path: 'admin',
  loadComponent: () => import('./admin/admin.component').then(m => m.AdminComponent),
}
```

### Lazy Loading Child Routes

Use `loadChildren` to fetch a set of routes.

```ts
{
  path: 'settings',
  loadChildren: () => import('./settings/settings.routes'),
}
```

## Injection Context and Lazy Loading

Loader functions run within the **injection context** of the current route. This allows you to call `inject()` to make context-aware loading decisions.

```ts
{
  path: 'dashboard',
  loadComponent: () => {
    const flags = inject(FeatureFlags);
    return flags.isPremium
      ? import('./premium-dashboard')
      : import('./basic-dashboard');
  },
}
```

## Recommendation

- Eager-load routes needed for initial rendering when an extra request would hurt the critical path.
- Lazy-load feature areas that are not needed initially. Choose a preloading strategy when later navigation latency matters.
