# Provider

Provides a specific functionality for a game. This type is not useful outside of
Oh My Prvd itself; prefer to use [`#!lua use(provider)`](../members/use.md) for
more precise types.

=== "Luau"

    ```Lua
    export type Provider<T> = T & {
      loadOrder: number?,

      init: ((self: Provider<T>) -> Promise?)?,
      start: (self: Provider<T>) -> ()?,
      heartbeat: (self: Provider<T>, dt: number) -> ()?,
      step: (self: Provider<T>, dt: number) -> ()?,
      render: (self: Provider<T>, dt: number) -> ()?,
    }
    ```

=== "TypeScript"

    ```TypeScript
    export type Provider<T extends object> = T & {
      loadOrder?: number,

      init?(): void | Promise<void>,
      start?(): void,
      heartbeat?(dt: number): void,
      step?(dt: number): void,
      render?(dt: number): void,
    }
    ```

---

## Members

### loadOrder `#!lua : number`

Determines when to initialize the provider. Defaults to `1`. This member is not
generally useful, as Oh My Prvd will figure out a load order with dependency
injection.

### init `#!lua : (self: Provider<T>) -> Promise?`

Runs sequentially before any other lifecycle methods, methods are expected to be
infallible and preferably non-yielding.

If it returns a promise, Oh My Prvd will await for the promise to resolve.

### start `#!lua : (self: Provider<T>) -> ()`

Runs concurrently *after* all other lifecycle methods have been registered. This
means failures and yields do not affect other providers.

### heartbeat: `#!lua : (self: Provider<T>, dt: number) -> ()`

Runs every `RunService.Heartbeat` and is optimal for responding to changes in
the physics state.

### step: `#!lua : (self: Provider<T>, dt: number) -> ()`

Runs every `RunService.Stepped` and is optimal for manipulating physics.

### render: `#!lua : (self: Provider<T>, dt: number) -> ()`

Runs every `RunService.RenderStepped`. Notably, this lifecycle event only runs on
the client.

---

## Learn More

- [Providers tutorial](../../../tutorials/providers.md)
