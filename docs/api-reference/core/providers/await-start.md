<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">hook</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: awaitStart

Yields the calling thread just before startup finishes. If Prvd 'M Wrong has
already started, the thread will continue.

=== "Luau"

    ```Luau
    function prvd.awaitStart(): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const awaitStart: () => void
    ```

## Learn More

- [startup tutorial](../../../tutorials/fundamentals/startup.md)
