# Route Transition Animations

For stable route motion in modern Angular applications, prefer **native CSS animations** and Angular's built-in **`animate.enter` / `animate.leave`** bindings inside routed page components.

## Default Approach

1. Keep `<router-outlet>` simple.
2. Animate the page shell inside each routed component.
3. Use opacity and transform-based motion for smooth, GPU-friendly transitions.
4. Respect reduced-motion preferences.

## Page Shell Pattern

Wrap each routed page in a stable container and animate that container when the route component enters the DOM.

```html
<section class="page-shell" animate.enter="page-enter" animate.leave="page-leave">
  <h1>Settings</h1>
  <p>Manage your profile, notifications, and security settings.</p>
</section>
```

```css
.page-shell {
  min-height: 100%;
}

.page-enter {
  animation: page-enter 180ms cubic-bezier(0, 0, 0.2, 1);
}

.page-leave {
  animation: page-leave 120ms cubic-bezier(0.4, 0, 1, 1);
}

@keyframes page-enter {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes page-leave {
  from {
    opacity: 1;
    transform: translateY(0);
  }
  to {
    opacity: 0;
    transform: translateY(-4px);
  }
}

@media (prefers-reduced-motion: reduce) {
  .page-enter,
  .page-leave {
    animation: none;
  }
}
```

## Nested Route Content

For dashboards and detail pages, animate the routed component shell first, then stagger inner sections with CSS delays.

```html
<section class="page-shell" animate.enter="page-enter">
  <header class="page-header">...</header>
  <div class="page-content content-enter">...</div>
</section>
```

```css
.content-enter {
  animation: content-enter 220ms 40ms both;
}

@keyframes content-enter {
  from {
    opacity: 0;
    transform: translateY(12px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

## Best Practices

- Keep route motion subtle and fast.
- Prefer `opacity` and `transform` over layout-affecting properties.
- Put shared page-transition classes in global styles when multiple routes reuse them.
- Use per-component styles when the motion is unique to one page.
- Do not add route transitions unless they improve clarity or perceived performance.
