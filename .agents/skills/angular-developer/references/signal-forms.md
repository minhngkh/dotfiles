# Signal Forms

Prefer Signal Forms for new forms. Keep an existing Reactive or template-driven form unless there is a concrete reason to migrate; all three form systems remain supported.

Import Signal Forms APIs from `@angular/forms/signals`.

## Model Design

A writable signal is the source of truth. `form()` creates a typed field tree that mirrors its current structure.

```ts
import {signal} from '@angular/core';
import {form} from '@angular/forms/signals';

interface ProfileFormModel {
  name: string;
  birthday: Date | null;
  address: {
    city: string;
  };
}

readonly profileModel = signal<ProfileFormModel>({
  name: '',
  birthday: null,
  address: {city: ''},
});

readonly profileForm = form(this.profileModel);
```

Follow these model rules:

- Initialize every field that must exist in the field tree.
- Use plain objects and arrays for structural nodes, not class instances, `Map`, or `Set`.
- Match leaf types to the bound control: text inputs use strings, number inputs use numbers, and checkboxes use booleans.
- Use `null` for an empty leaf only when the bound control accepts it. Native text inputs and textareas use `''`.
- Exclude `undefined` and optional properties from form fields. An `undefined` property is treated as absent from the field tree.
- Initialize a nested object with empty leaf values when its children must be bound independently.
- Prefer a form-specific model for raw UI input and translate to the domain or API model at the form boundary.

The model and field value stay synchronized in both directions:

```ts
this.profileModel.set(loadedProfile);
this.profileForm.name().value.set('Alice');
this.profileForm.address.city().value.update((city) => city.trim());
```

## Setup And Binding

Import `FormField` in each component that uses `[formField]`. Import `FormRoot` for declarative form submission.

```ts
import {Component, signal} from '@angular/core';
import {form, FormField, FormRoot} from '@angular/forms/signals';

@Component({
  imports: [FormField, FormRoot],
  template: `
    <form [formRoot]="profileForm">
      <label>
        Name
        <input [formField]="profileForm.name" />
      </label>

      <button type="submit" [disabled]="profileForm().submitting()">Save</button>
    </form>
  `,
})
export class ProfileEditor {
  readonly profileModel = signal({name: ''});
  readonly profileForm = form(this.profileModel);
}
```

`[formField]` two-way binds the value, relays interaction into field state, and synchronizes applicable state such as `required`, `disabled`, and `readonly`. It supports native controls, Signal Forms custom controls, and existing `ControlValueAccessor` controls through compatibility support.

Use one forms API per control. A control with `[formField]` does not also use `[(ngModel)]`, `[formControl]`, or `formControlName`.

## Field State

Navigate a field-tree node without calling it, then call it to obtain field state:

```ts
profileForm.address.city;           // FieldTree<string>
profileForm.address.city().value(); // string
profileForm.address.city().valid(); // boolean
profileForm().dirty();              // aggregated root state
```

Common state signals include:

- `value()`: current writable value.
- `valid()`, `invalid()`, and `pending()`: validation state.
- `errors()`: errors on this field.
- `errorSummary()`: errors on this field and its descendants.
- `touched()` and `dirty()`: interaction state.
- `disabled()`, `hidden()`, and `readonly()`: availability state.
- `submitting()`: whether a submission action is running.

`valid()` is not equivalent to `!invalid()`. While async validation is pending, both can be `false`.

Reveal errors after interaction:

```html
@if (profileForm.name().touched() && profileForm.name().invalid()) {
  @for (error of profileForm.name().errors(); track error) {
    <p>{{ error.message ?? error.kind }}</p>
  }
}
```

State operations include:

```ts
this.profileForm.address().markAsTouched();
this.profileForm().reset();
this.profileForm().reset(emptyModel);
```

Disabled, hidden, and readonly fields are non-interactive and do not contribute to parent validity, touched, or dirty state. `hidden()` changes form state; use `@if` to remove the control from the UI.

## Validation

Define rules in the schema function passed to `form()`:

```ts
import {email, form, min, required, validate} from '@angular/forms/signals';

readonly registrationForm = form(this.registrationModel, (path) => {
  required(path.email, {message: 'Email is required'});
  email(path.email, {message: 'Enter a valid email address'});
  min(path.age, 18, {message: 'You must be at least 18'});

  validate(path.confirmPassword, ({value, valueOf}) =>
    value() === valueOf(path.password)
      ? null
      : {kind: 'passwordMismatch', message: 'Passwords do not match'},
  );
});
```

Common built-in rules include `required`, `email`, `min`, `max`, `minDate`, `maxDate`, `minLength`, `maxLength`, and `pattern`.

Custom validators return an error object when invalid and `null` or `undefined` when valid. Use `valueOf(path.otherField)` for reactive cross-field dependencies.

- Synchronous rules run before asynchronous rules.
- Async validation starts only after synchronous validation passes.
- Multiple rules can report multiple errors.
- `required()` treats `null`, `''`, and `false` as empty, but treats an empty array as present. Use `minLength(path, 1)` for a non-empty array.
- Read validation from field state rather than native `validity`, `validationMessage`, or CSS validity pseudo-classes.

Use schema rules such as `disabled()`, `hidden()`, and `readonly()` for declarative availability:

```ts
hidden(path.shippingAddress, {
  when: ({valueOf}) => !valueOf(path.requiresShipping),
});
```

## Submission

Prefer `FormRoot` with submission options on `form()`:

```ts
readonly contactForm = form(
  this.contactModel,
  (path) => {
    required(path.name);
    email(path.email);
  },
  {
    submission: {
      ignoreValidators: 'none',
      action: async (field) => {
        const result = await this.contactApi.save(field().value());

        return result.ok
          ? undefined
          : {kind: 'server', message: result.message, fieldTree: field.email};
      },
      onInvalid: (field) => {
        field().errorSummary()[0]?.fieldTree().focusBoundControl();
      },
    },
  },
);
```

```html
<form [formRoot]="contactForm">
  <input [formField]="contactForm.name" />
  <input type="email" [formField]="contactForm.email" />
  <button type="submit" [disabled]="contactForm().submitting()">Save</button>
</form>
```

`FormRoot` sets `novalidate`, prevents native navigation, and invokes submission. Submission marks interactive fields touched, applies validation gating, prevents concurrent actions, exposes `submitting()`, and routes returned errors to the submitted field or supplied `fieldTree`.

The default `ignoreValidators` value is `'pending'`. Set it to `'none'` when all async validation must finish before the action runs.

Manual submission is also supported:

```ts
const success = await submit(this.contactForm, async (field) => {
  await this.contactApi.save(field().value());
});

if (success) {
  await this.router.navigate(['/complete']);
}
```

## Async Validation

Use `validateHttp()` for HTTP validation:

```ts
validateHttp(path.username, {
  debounce: 300,
  request: ({value}) => {
    const username = value();
    return username
      ? `/api/users/available?username=${encodeURIComponent(username)}`
      : undefined;
  },
  onSuccess: (response: {available: boolean}) =>
    response.available
      ? null
      : {kind: 'usernameTaken', message: 'Username is already taken'},
  onError: () => ({
    kind: 'validationUnavailable',
    message: 'Could not verify username availability',
  }),
});
```

Return `undefined` from `request` to skip the operation. Pending requests are cancelled when parameters change. Use `field().pending()` to show progress.

Use lower-level `validateAsync()` for resource-based non-HTTP work or custom resource composition. Its required options are `params`, `factory`, `onSuccess`, and `onError`.

## Arrays

Arrays may grow and shrink, but each item should have a consistent shape.

```ts
readonly orderModel = signal({items: [] as {name: string; quantity: number}[]});

readonly orderForm = form(this.orderModel, (path) => {
  applyEach(path.items, (item) => {
    required(item.name);
    min(item.quantity, 1);
  });
});

addItem() {
  this.orderModel.update((model) => ({
    ...model,
    items: [...model.items, {name: '', quantity: 1}],
  }));
}
```

Iterate over fields and track field identity:

```html
@for (item of orderForm.items; track item) {
  <input [formField]="item.name" />
  <input type="number" [formField]="item.quantity" />
}
```

## Existing Forms And Migration

Existing Reactive Forms remain appropriate for established observable-based form code and third-party integrations, with explicit interoperability:

- `compatForm()` from `@angular/forms/signals/compat` places existing `FormControl` or `FormGroup` instances inside a Signal Form model.
- `SignalFormControl` from `@angular/forms/signals/compat` places a signal-backed control inside an existing `FormGroup` or `FormArray`.
- Bind a `SignalFormControl` with `[formField]="control.fieldTree"`, not `formControlName` or `[formControl]`.
- Existing `ControlValueAccessor` controls can use `[formField]`. For new Signal Forms controls, prefer `FormValueControl` or `FormCheckboxControl`.
- A custom control implements either `ControlValueAccessor` or a Signal Forms control contract, not both.

## Common Pitfalls

- Field nodes are not callable until read: use `form.field().value()` and `form().invalid()`. Never call `form.field.set(x)` — update the model signal instead.
- `applyWhen(path, condition, schemaFn)` takes the path first and exactly three arguments.
- `validateAsync` requires a `params` function (`params: ({value}) => value()`) and a mandatory `onError` handler.
- Checkboxes bind only to `boolean` leaves; for array values use `<select multiple>` or separate boolean fields.
- Templates have no `$parent.$index`; capture the outer index with `let outerIndex = $index`.
- Use schema rules (`readonly()`, `hidden()`, `disabled()`) instead of HTML `readonly`, `min`, `max`, or `value` attributes with `[formField]`.

## Official Sources

- `https://angular.dev/guide/forms/signals/overview`
- `https://angular.dev/guide/forms/signals/model-design`
- `https://angular.dev/guide/forms/signals/field-state-management`
- `https://angular.dev/guide/forms/signals/validation`
- `https://angular.dev/guide/forms/signals/form-submission`
- `https://angular.dev/guide/forms/signals/async-operations`
- `https://angular.dev/guide/forms/signals/migration`
