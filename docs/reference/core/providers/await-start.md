<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span class="ompdoc-reference-highlight">hook</span>
<span class="ompdoc-reference-since">since v0.1</span>
</div>

# :octicons-workflow-16: awaitStart

Yields the calling thread just before startup finishes. If Oh My Prvd has
already started, the thread will continue.

=== "Luau"

    ```Lua
    function prvd.awaitStart(): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const awaitStart: () => void
    ```

---

## Learn More

- [startup tutorial](../../../tutorials/fundamentals/startup.md)
