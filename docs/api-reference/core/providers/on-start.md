<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">workflow</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: onStart

Queues a callback to be called just before startup finishes. If Prvd 'M Wrong has
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

## Parameters

### callback `#!lua : () -> ()`

The callback to be spawned just before startup finishes.

## Learn More

- [startup tutorial](../../../tutorials/fundamentals/startup.md)
