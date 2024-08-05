<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">constructor</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-package-16: Provider

Constructs and returns a new [provider](../types/provider.md) within Prvd 'M Wrong.
Providers must be created before calling `prvd.start(options)`.

=== "Luau"

    ```Lua
    function prvd.Provider<T>(
      name: string,
      provider: T
    ): Provider<T>
    ```

    ??? tip "Too verbose?"

        If writing `#!lua prvd.Provider` sounds verbose for you, Prvd 'M Wrong
        aliases the `Provider` constructor with `new`:

        ```Lua
        local prvd = require(ReplicatedStorage.Packages.prvdmwrong)

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

The methods and properties of the provider. All lifecycle methods will be
registered during startup. The provider may also specify a `loadOrder` property
which dictates when the provider is loaded, and defaults to one.

---

## Returns `#!lua : Provider<T>`

[A freshly registered provider.](../types/provider.md)

---

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
