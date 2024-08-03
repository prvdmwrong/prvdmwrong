<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span class="ompdoc-reference-highlight">workflow</span>
<span class="ompdoc-reference-since">since v0.1</span>
</div>

# :octicons-hook-16: onStart

Queues a callback to be called just before startup finishes. If Oh My Prvd has
already started, the callback will be spawned immediately.

=== "Luau"

    ```Lua
    function prvd.onStart(
      callback: () -> ()
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const onStart: (
      callback: () => void
    ) => void
    ```

---

## Parameters

### callback `#!lua : () -> ()`

The callback to be spawned just before startup finishes.

## Learn More

- [startup tutorial](../../../tutorials/fundamentals/startup.md)
