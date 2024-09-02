<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Modding</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">hook</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: onProviderConstructed

Called just before Prvd 'M Wrong returns a newly constructed
[provider](../types/provider.md). Handlers are expected to be infallible and
non-yielding. The handler receives the constructed provider.

=== "Luau"

    ```Luau
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

## Parameters

### handler `#!lua : (Provider<unknown>) -> void`

A handler that is called just before a newly constructed provider is returned.
It receives the provider.
