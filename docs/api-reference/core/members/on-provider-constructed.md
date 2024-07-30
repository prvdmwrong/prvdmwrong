<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# onProviderConstructed

Called just before Oh My Prvd returns a newly constructed
[provider](../types/provider.md). Handlers are expected to be infallible and
non-yielding. The handler receives the constructed provider.

=== "Luau"

    ```Lua
    function prvd.onProviderConstructed(
      handler: (Provider<unknown>) -> ()
    ) -> (),
    ```

=== "TypeScript"

    ```TypeScript
    export const onProviderConstructed: (
      handler: (provider: Provider<object>) => void,
    ) => void
    ```

---

## Parameters

### handler `#!lua : (Provider<unknown>) -> void`

A handler that is called just before a newly constructed provider is returned.
It receives the provider.
