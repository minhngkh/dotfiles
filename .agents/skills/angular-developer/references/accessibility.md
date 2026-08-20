# Accessibility Fundamentals

Prefer native HTML semantics before adding ARIA or a custom interaction model. Native buttons, links, inputs, labels, headings, landmarks, and form validation expose behavior to assistive technology with less custom code.

## Accessible Names And Structure

- Give every interactive control an accessible name through visible text, a `<label>`, `aria-label`, or `aria-labelledby`.
- Associate validation and help text with its control using `aria-describedby` when the relationship is not already expressed by native HTML.
- Keep heading levels and landmark regions meaningful. Do not choose elements for their default appearance.
- Provide useful alternative text for informative images and empty `alt` text for decorative images.

Angular attribute bindings use the `attr.` prefix for ARIA attributes:

```html
<button
  type="button"
  [attr.aria-expanded]="expanded()"
  [attr.aria-controls]="panelId"
  (click)="expanded.update(value => !value)"
>
  Details
</button>
<section [id]="panelId" [hidden]="!expanded()">...</section>
```

Use Angular Aria or another tested component library for composite widgets such as comboboxes, menus, tabs, trees, and grids. Read [angular-aria.md](angular-aria.md) when implementing those patterns.

## Keyboard And Focus

- Every pointer interaction must have an equivalent keyboard interaction.
- Preserve the browser's visible focus indicator or replace it with an equally visible `:focus-visible` style.
- Keep DOM order aligned with visual and focus order.
- Move focus only when the interaction requires it, such as opening a modal or reporting a blocking error. Return focus to the initiating control when a temporary surface closes.
- Use established WAI-ARIA keyboard patterns for composite widgets rather than inventing key behavior.

## Dynamic Content

Use a live region for important asynchronous status that is not otherwise announced. Keep the region present in the DOM and update its text.

```html
<p aria-live="polite" aria-atomic="true">{{ saveStatus() }}</p>
```

Reserve `role="alert"` or `aria-live="assertive"` for urgent information that should interrupt current speech.

## Verification

For changed UI:

1. Navigate the complete interaction using only the keyboard.
2. Confirm focus order, focus visibility, accessible names, roles, states, and validation messages.
3. Run the project's accessibility checks or browser audit when available.
4. Test the affected flow with a screen reader when the change introduces a custom widget or focus management.

Use the current Angular accessibility guidance at `https://angular.dev/best-practices/a11y` and the WAI-ARIA Authoring Practices at `https://www.w3.org/WAI/ARIA/apg/` for patterns not covered here.
