# Using Tailwind CSS with Angular

Tailwind CSS is a utility-first CSS framework that integrates seamlessly with Angular.

Inspect the installed Tailwind major first. Use the v4 instructions below for new or v4 projects. Preserve a working v3 configuration unless the task is an explicit Tailwind migration.

## Automated Setup (Recommended)

The easiest way to add Tailwind CSS to an Angular project is via the Angular CLI:

```shell
ng add tailwindcss
```

This will automatically:

1. Install `tailwindcss` and peer dependencies.
2. Configure the project to use Tailwind CSS.
3. Add the proper import to your global styles.

## Manual Setup (Tailwind v4)

If setting up manually, use the following Tailwind v4 pattern:

### 1. Install Dependencies

Install `tailwindcss`, `@tailwindcss/postcss`, and `postcss` using the project's configured package manager. For npm:

```shell
npm install tailwindcss @tailwindcss/postcss postcss
```

### 2. Configure PostCSS

Create a `.postcssrc.json` file in the project root:

```json
{
  "plugins": {
    "@tailwindcss/postcss": {}
  }
}
```

Prefer v4 CSS-first configuration with directives such as `@theme`. A JavaScript config is not required, but an existing legacy config can be loaded with `@config` during migration.

### 3. Import Tailwind CSS

In your global styles file (e.g., `src/styles.css`), add the standard v4 import:

```css
@import 'tailwindcss';
```

Prefer a CSS global entry point for new Tailwind v4 setups. Preserve SCSS only when the project already requires it; Tailwind v4 is not designed for Sass preprocessing.

### 4. Use Utility Classes

You can now use Tailwind classes directly in your component templates:

```html
<h1 class="text-3xl font-bold underline">Hello world!</h1>
```

## Version Summary

- Tailwind v4 uses `@import 'tailwindcss';` instead of the v3 `@tailwind` directives.
- Prefer CSS theme variables and CSS-first configuration for v4.
- Preserve v3 syntax and configuration in v3 projects until a migration is explicitly requested.
