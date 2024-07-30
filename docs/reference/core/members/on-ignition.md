<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

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

- [Ignition tutorial](../../../get-started/ignition.md)
