# awaitIgnition

Yields the calling thread just before ignition finishes. If Oh My Prvd has
already started, the thread will continue.

=== "Luau"

    ```Lua
    function prvd.awaitIgnition(): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const awaitIgnition: () => void
    ```

---

## Learn More

- [Ignition tutorial](../../../tutorials/ignition.md)
