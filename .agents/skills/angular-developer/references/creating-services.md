# Creating and Using Services

Services in Angular are reusable pieces of code that handle data fetching, business logic, or state management that multiple components or other services need to access.

## Creating a Service

Preserve the workspace's suffix conventions — modern workspaces use suffixless files, some projects use `.service` filenames.

Use `@Service()` for a typical root singleton that uses `inject()`:

```ts
import {Service} from '@angular/core';

@Service()
export class BasicDataStore {
  private data: string[] = [];

  addData(item: string): void {
    this.data.push(item);
  }

  getData(): string[] {
    return [...this.data];
  }
}
```

### The `@Service` decorator

`@Service` tells Angular to:

- **Create a single instance (singleton)** for the entire application.
- **Make it available everywhere** automatically, without needing to list it in any `providers` array.
- **Enable tree-shaking**, meaning the service is only included in the final JavaScript bundle if it is actually injected somewhere.

For older projects, or when constructor injection or advanced `providedIn` scopes are required, use `@Injectable`:

```ts
import {Injectable} from '@angular/core';

@Injectable({providedIn: 'root'})
export class BasicDataStore {}
```

Preserve the decorator used by the installed Angular version unless an upgrade was requested.

#### The `autoProvided` option

Use `@Service({autoProvided: false})` when a service should never be automatically root-provided. Then register it in the appropriate `providers` array.

## Injecting a Service

Once a service is created, you can inject it into components, directives, or other services using the `inject()` function.

### Injecting into a Component

```ts
import {Component, inject} from '@angular/core';
import {BasicDataStore} from './basic-data-store';

@Component({
  selector: 'app-example',
  template: `
    <div>
      <p>Data items: {{ dataStore.getData().length }}</p>
      <button (click)="dataStore.addData('New Item')">Add Item</button>
    </div>
  `,
})
export class Example {
  // Inject the service as a class field
  dataStore = inject(BasicDataStore);
}
```

### Injecting into Another Service

Services can inject other services in the exact same way.

```ts
import {Service, inject} from '@angular/core';
import {AdvancedDataStore} from './advanced-data-store';

@Service()
export class BasicDataStore {
  // Injecting another service
  private advancedDataStore = inject(AdvancedDataStore);

  private data: string[] = [];

  getData(): string[] {
    // Combine data from this service and the injected service
    return [...this.data, ...this.advancedDataStore.getData()];
  }
}
```

## Advanced Service Patterns

While `@Service` covers most scenarios, you may sometimes need:

- **Component-specific instances**: Provide the service in `@Component({providers: [MyService]})`. Set `autoProvided: false` only when it should never also be available from the root injector.
- **Factory providers**: For dynamic creation.
- **Value providers**: For injecting configuration objects.
