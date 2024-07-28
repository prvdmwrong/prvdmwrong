# onIgnition

Queues a callback to be called just before ignition finishes. If Oh My Prvd has
already started, the callback will be spawned immediately.

=== "Luau"

    ```Lua
    function prvd.onIgnition(
      callback: () -> ()
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const onIgnition: (
      callback: () => void
    ) => void
    ```

---

## Parameters

### callback `#!lua : () -> ()`

The callback to be spawned just before ignition finishes.

## Learn More

- [Ignition tutorial](../../../tutorials/ignition.md)
