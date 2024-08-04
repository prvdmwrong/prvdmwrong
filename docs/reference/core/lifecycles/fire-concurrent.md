<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Lifecycles</a>
</div>
<div class="ompdoc-reference-tags">
<span class="ompdoc-reference-highlight">function</span>
<span class="ompdoc-reference-since">since v0.2</span>
</div>

# :octicons-package-16: fireConcurrent

A function that spawns all listeners of a [lifecycle](../types/lifecycle.md)
asynchronously. Intended to be used as the `fire` argument of the
[lifecycle](../types/lifecycle.md) constructor.

=== "Luau"

    ```Lua
    function prvd.fireConcurrent(
      self: Lifecycle,
      ...: unknown
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export function fireConcurrent: (
      lifecycle: Lifecycle,
      ...args: unknown[]
    ) => void
    ```

---

## Parameters

### self `#!lua : Lifecycle`

The lifecycle object that should have its listeners ran.

### ... `#!lua : unknown`

Arguments to call the listeners' method.

---

## Learn More

- [Lifecycles tutorial](../../../tutorials/fundamentals/lifecycles.md)
