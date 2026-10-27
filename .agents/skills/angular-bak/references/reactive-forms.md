# Reactive Forms

In modern Angular applications, prefer **typed reactive forms** for production form workflows.
They are stable, model-driven, scalable, and work well for validation-heavy, dynamic, reusable, and multi-step forms.

## Default Recommendation

- Prefer **typed reactive forms** for new non-trivial forms.
- Prefer **non-nullable controls** unless `null` is a real domain value.
- Keep form creation in TypeScript and keep templates focused on binding and error display.
- Use template-driven forms only for small, simple forms.

## Core Classes

Reactive forms are built using these fundamental classes from `@angular/forms`:

- `FormControl`: Manages the value and validity of an individual input.
- `FormGroup`: Manages a group of controls (an object-like structure).
- `FormArray`: Manages a numerically indexed array of controls.
- `NonNullableFormBuilder`: A builder for strongly typed, non-nullable controls.

## Setup

Import `ReactiveFormsModule` into your component.

```ts
import { Component, inject } from '@angular/core';
import { ReactiveFormsModule, Validators, NonNullableFormBuilder, FormArray } from '@angular/forms';

@Component({
  selector: 'app-profile-editor',
  imports: [ReactiveFormsModule],
  templateUrl: './profile-editor.component.html',
})
export class ProfileEditor {
  private readonly fb = inject(NonNullableFormBuilder);

  readonly profileForm = this.fb.group({
    firstName: this.fb.control('', { validators: [Validators.required] }),
    lastName: this.fb.control(''),
    address: this.fb.group({
      street: this.fb.control(''),
      city: this.fb.control(''),
    }),
    aliases: this.fb.array([this.fb.control('')]),
  });

  onSubmit() {
    if (this.profileForm.invalid) {
      this.profileForm.markAllAsTouched();
      return;
    }

    console.warn(this.profileForm.getRawValue());
  }
}
```

## Template Binding

Use directives to bind the model to the view:

- `[formGroup]`: Binds a `FormGroup` to a `<form>` or `<div>`.
- `formControlName`: Binds a named control within a group to an input.
- `formGroupName`: Binds a nested `FormGroup`.
- `formArrayName`: Binds a nested `FormArray`.
- `[formControl]`: Binds a standalone `FormControl`.

```html
<form [formGroup]="profileForm" (ngSubmit)="onSubmit()">
  <input type="text" formControlName="firstName" />

  <div formGroupName="address">
    <input type="text" formControlName="street" />
  </div>

  <div formArrayName="aliases">
    @for (alias of aliases.controls; track $index) {
    <input type="text" [formControlName]="$index" />
    }
  </div>

  <button type="submit" [disabled]="!profileForm.valid">Submit</button>
</form>
```

## Accessing Controls

Use getters for easy access to controls, especially for `FormArray`.

```ts
get aliases() {
  return this.profileForm.get('aliases') as FormArray;
}

addAlias() {
  this.aliases.push(this.fb.control(''));
}
```

## Updating Values

- `patchValue()`: Updates only the specified properties. Fails silently on structural mismatches.
- `setValue()`: Replaces the entire model. Strictly enforces the form structure.
- `getRawValue()`: Reads the full typed value, including disabled controls.

```ts
updateProfile() {
  this.profileForm.patchValue({
    firstName: 'Nancy',
    address: { street: '123 Drew Street' }
  });
}
```

## Unified Change Events

Modern Angular (v18+) provides a single `events` observable on all controls to track value, status, pristine, touched, reset, and submit events.

```ts
import { ValueChangeEvent, StatusChangeEvent } from '@angular/forms';

this.profileForm.events.subscribe((event) => {
  if (event instanceof ValueChangeEvent) {
    console.log('New value:', event.value);
  }
});
```

## Manual State Management

- `markAsTouched()` / `markAllAsTouched()`: Useful for showing validation errors on submit.
- `markAsDirty()` / `markAsPristine()`: Tracks if the value has been modified.
- `updateValueAndValidity()`: Manually triggers recalculation of value and status.
- Options `{ emitEvent: false }` or `{ onlySelf: true }` can be passed to most methods to control propagation.

## Best Practices

- Prefer `NonNullableFormBuilder` for stable typed forms.
- Keep cross-field validation in custom validators attached to the group.
- Use `FormArray` for repeatable sections instead of manually indexing plain arrays.
- Derive submit payloads from `getRawValue()` after validation passes.
- Keep templates declarative: bind controls, show errors, avoid form construction logic in HTML.
