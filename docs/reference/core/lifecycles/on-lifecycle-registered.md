<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Lifecycles</a>
</div>

<div class="ompdoc-reference-tags">
<span class="ompdoc-reference-highlight">hook</span>
<span class="ompdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: onMethodRegistered

Called when an object registers a lifecycle method. Handlers are expected to be
infallible and non-yielding. The handler receives the constructed provider.

=== "Luau"

    ```Lua
    function prvd.onMethodRegistered(
      method: string,
      handler: (Provider<unknown>) -> ()
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const onMethodRegistered: (
      method: string,
      handler: (Provider<unknown>) => void
    ) => void
    ```

---

## Parameters

### method `#!lua : string`

The method to implement. During startup, all providers that specify this method
will have its handler be called.

### handler `#!lua : (Provider<unknown>) -> void`

A handler for providers that implement the specified methods. It receives the
provider which implements the method. Commonly used to implement custom
lifecycles by adding providers to a "watchlist" which will have its methods
fired.
