# Provider

Constructs and returns a new provider within Oh My Prvd. Providers must be
created before calling `Prvd.ignite()`.

=== "Luau"

    ```Lua
    function prvd.Provider<T>(
      name: string,
      provider: T
    ): Provider<T>
    ```

    ??? tip "Too verbose?"

        If writing `#!lua prvd.Provider` sounds verbose for you, Oh My Prvd
        aliases the `Provider` constructor with `new`:

        ```Lua
        local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

        local PointsProvider = {}
        return prvd.new("PointsProvider", PointsProvider)
        ```

        For consistency, we recommend using `Provider` when favorable, as
        `new` is a reserved keyword in TypeScript.

=== "TypeScript"

    ```TypeScript
    export const Provider: <T extends object>(
      name: string,
      provider: T
    ) => Provider<T>
    ```

---

## Parameters

### name `#!lua : string`

A unique name to identify the provider with. This will be used for debugging.

### provider `#!lua : T`

The methods and properties of the provider. Oh My Prvd provides a handful of
lifecycle methods which may be specified:

- `:init` runs sequentially before any other lifecycle methods, methods are
  expected to be infallible and preferably non-yielding.
- `:start` runs concurrently *after* all other lifecycle methods have been
  registered. This means failures and yields do not affect other providers.
- `:heartbeat` is ran every `RunService.Heartbeat` and is optimal for responding
  to changes in the physics state.
- `:step` is ran every `RunService.Stepped` and is optimal for manipulating
  physics.
- `:render` is ran every `RunService.RenderStepped`. Notably, this lifecycle
  event only runs on the client.

In addition, the provider may also specify a `loadOrder` property which
dictates when the provider is loaded, defaults to `1`.

---

## Returns `#!lua : Provider<T>`

A freshly registered provider.

---

## Learn More

- [Providers tutorial](../../../tutorials/providers.md)
