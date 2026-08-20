# Angular Aria

Angular Aria provides headless directives for custom WAI-ARIA composite widgets. It supplies interaction, focus management, keyboard behavior, and accessibility semantics while the application supplies structure, styling, and business state.

Inspect `package.json` before using Angular Aria. If a compatible `@angular/aria` package is absent and the user wants it, install it with the project's configured package manager. Read the documentation matching the installed package version.

## Choose The Primitive

Prefer native HTML when it provides the required behavior. Use Angular Aria when the design requires a custom composite-widget interaction model.

| Pattern | Use for | Official guide |
| :--- | :--- | :--- |
| Accordion | Expandable content sections | `https://angular.dev/guide/aria/accordion` |
| Combobox | Editable input with a popup or custom select | `https://angular.dev/guide/aria/combobox` |
| Grid | Two-dimensional interactive data navigation | `https://angular.dev/guide/aria/grid` |
| Listbox | Custom single- or multi-select option list | `https://angular.dev/guide/aria/listbox` |
| Menu | Action menus and menubars | `https://angular.dev/guide/aria/menu` |
| Tabs | One active panel selected from related views | `https://angular.dev/guide/aria/tabs` |
| Toolbar | Arrow-key navigation through grouped controls | `https://angular.dev/guide/aria/toolbar` |
| Tree | Hierarchical expandable selection | `https://angular.dev/guide/aria/tree` |

Before writing a pattern, read its official guide for the installed package version. Copy its required directive hierarchy and imports as a unit rather than guessing which directives compose.

## Headless Styling

Style every interactive state the selected directives expose:

- Visible keyboard focus.
- Expanded and collapsed state.
- Selected, checked, or pressed state.
- Disabled state.
- Active descendant or current item.
- Popup position, visibility, and stacking.

Inspect the rendered attributes and directive API. Some directives write ARIA state attributes; others expose state that the template must bind explicitly.

```html
<button
  ngToolbarWidget
  value="bold"
  #bold="ngToolbarWidget"
  [attr.aria-pressed]="bold.selected()"
>
  Bold
</button>
```

```css
button[aria-pressed='true'] {
  background: var(--selected-control-background);
}

button:focus-visible {
  outline: 2px solid var(--focus-ring-color);
  outline-offset: 2px;
}
```

The widget remains responsible for accessible names and surrounding semantics. Read [accessibility.md](accessibility.md) for general naming, focus, and verification rules.

## Signal Forms

Angular Aria integrates with Signal Forms. Read [signal-forms.md](signal-forms.md) before binding an Aria widget with `[formField]`.

- Match the form-model leaf type to the widget value, including array values for multi-selection.
- Read field state by calling the field tree node, for example `form.city().value()`.
- Keep one form API on each control; do not combine `[formField]` with `ngModel` or Reactive Forms bindings.
- Preserve an existing Reactive or template-driven form unless migration is part of the task.

## Testing

Use the harness exported by the installed Angular Aria pattern package when one is available. Read [component-harnesses.md](component-harnesses.md) and [testing-fundamentals.md](testing-fundamentals.md).

Use the assertion syntax configured by the project.

For each changed widget, verify:

1. Keyboard navigation and activation.
2. Focus movement and restoration.
3. Accessible name, role, state, and relationships.
4. Single- and multi-selection behavior where applicable.
5. Disabled items and boundary navigation.
6. Screen-reader output for the affected interaction.

## Official Sources

- `https://angular.dev/guide/aria/overview`
- `https://angular.dev/api/aria`
- `https://www.w3.org/WAI/ARIA/apg/patterns/`
