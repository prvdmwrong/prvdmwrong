<div class="ompdoc-api-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# awaitStart

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
