<div class="ompdoc-api-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

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

- [Ignition tutorial](../../../tutorials/fundamentals/ignition.md)
