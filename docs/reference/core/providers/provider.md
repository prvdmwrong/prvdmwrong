<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# Provider

Constructs and returns a new [provider](../types/provider.md) within Oh My Prvd. Providers must be
created before calling `prvd.start(options)`.

=== "Luau"

    ```Lua
    function prvd.Provider<T>(
      provider: T
    ): Provider<T>
    ```

    ??? tip "Too verbose?"

        If writing `#!lua prvd.Provider` sounds verbose for you, Oh My Prvd
        aliases the `Provider` constructor with `new`:

        ```Lua
        local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

        local PointsProvider = {}
        return prvd.new(PointsProvider)
        ```

        For consistency, we recommend using `Provider` when favorable, as
        `new` is a reserved keyword in TypeScript.

=== "TypeScript"

    ```TypeScript
    export const Provider: <T extends object>(
      provider: T
    ) => Provider<T>
    ```

---

## Parameters

### provider `#!lua : T`

The methods and properties of the provider. Oh My Prvd provides two lifecycle
methods out of the box which may be specified:

- `:onInit` runs sequentially before any other lifecycle methods, methods are
  expected to be infallible and preferably non-yielding.
- `:onStart` runs concurrently *after* all other lifecycle methods have been
  registered. This means failures and yields do not affect other providers.

In addition, the provider may also specify a `loadOrder` property which
dictates when the provider is loaded, defaults to one.

---

## Returns `#!lua : Provider<T>`

A freshly registered provider.

---

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
