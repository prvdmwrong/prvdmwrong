# implementMethod

Listen for when a provider implements a lifecycle method. Commonly used to
implement custom lifecycles by adding providers to a "watchlist" which will have
its methods fired.

=== "Luau"

    ```Lua
    function prvd.implementMethod(
      method: string,
      handler: (Provider<unknown>) -> ()
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const implementMethod: (
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
