<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Modding</a>
</div>

<div class="ompdoc-reference-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# onProviderUsed

Called just before Oh My Prvd returns a used
[provider](../types/provider.md). Handlers are expected to be infallible and
non-yielding. The handler receives the used provider.

=== "Luau"

    ```Lua
    function prvd.onProviderUsed(
      handler: (Provider<unknown>) -> ()
    ) -> (),
    ```

=== "TypeScript"

    ```TypeScript
    export const onProviderUsed: (
      handler: (provider: Provider<object>) => void,
    ) => void
    ```

---

## Parameters

### handler `#!lua : (Provider<unknown>) -> void`

A handler that is called when a provider has been used. It receives the target
provider.
