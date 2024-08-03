<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Modding</a>
</div>

<div class="ompdoc-reference-tags">
<span class="ompdoc-reference-highlight">hook</span>
<span class="ompdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: onProviderConstructed

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
