<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Modding</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">hook</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: onProviderUsed

Called just before Prvd 'M Wrong returns a used
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
