<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# onMethodImplemented

Called when a provider implements a method. Handlers are expected to be
infallible and non-yielding. The handler receives the constructed provider.
Commonly used to implement custom lifecycles by adding providers to a
"watchlist" which will have its methods fired.

=== "Luau"

    ```Lua
    function prvd.onMethodImplemented(
      method: string,
      handler: (Provider<unknown>) -> ()
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const onMethodImplemented: (
      method: string,
      handler: (Provider<unknown>) => void
    ) => void
    ```

---

## Parameters

### method `#!lua : string`

The method to implement. During ignition, all providers that specify this method
will have its handler be called.

### handler `#!lua : (Provider<unknown>) -> void`

A handler for providers that implement the specified methods. It receives the
provider which implements the method. Commonly used to implement custom
lifecycles by adding providers to a "watchlist" which will have its methods
fired.
