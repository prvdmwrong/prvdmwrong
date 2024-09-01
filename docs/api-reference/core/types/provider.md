<div class="pmwdoc-reference-breadcrumbs">
<a href="../../">Prvd 'M Wrong</a>
<a href="../">Core</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">type</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-checklist-16: Provider

Provides a specific functionality for a game. This type is not useful outside of
Prvd 'M Wrong itself; prefer to import providers directly for more precise
types.

=== "Luau"

    ```TypeScript
    export type Provider<T> = T & {
      loadOrder: number?,
      onInit: ((self: Provider<T>) -> Promise?)?,
      onStart: (self: Provider<T>) -> ()?
    }
    ```

=== "TypeScript"

    ```TypeScript
    export type Provider<T extends object> = T & {
      loadOrder?: number,
      onInit?(): void | Promise<void>,
      onStart?(): void
    }
    ```

## Members

### loadOrder `#!lua : number`

Determines when to initialize the provider. Defaults to one. This member is not
generally useful, as Prvd 'M Wrong will figure out a load order with dependency
injection.

### onInit `#!lua : (self: Provider<T>) -> Promise?`

Runs sequentially before any other lifecycle methods, methods are expected to be
infallible and preferably non-yielding.

If it returns a promise, Prvd 'M Wrong will await for the promise to resolve.

### onStart `#!lua : (self: Provider<T>) -> ()`

Runs concurrently *after* all other lifecycle methods have been registered. This
means failures and yields do not affect other providers.

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
