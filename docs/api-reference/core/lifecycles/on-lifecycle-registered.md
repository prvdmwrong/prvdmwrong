<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Lifecycles</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">hook</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: onLifecycleRegistered

Called when an object registers a lifecycle method. Handlers are expected to be
infallible and non-yielding. The handler receives the constructed provider.

=== "Luau"

    ```Luau
    function prvd.onLifecycleRegistered(
      method: string,
      handler: (Provider<unknown>) -> ()
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const onLifecycleRegistered: (
      method: string,
      handler: (provider: Provider<unknown>) => void
    ) => void
    ```

## Parameters

### method `#!lua : string`

The method that is registered. During startup, all providers will have its
lifecycles registered.

### handler `#!lua : (Provider<unknown>) -> void`

A handler for providers that register the specified method. It receives the
provider which implements the method.
