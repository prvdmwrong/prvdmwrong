<div class="ompdoc-api-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Loader</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# matchesName

Constructs and returns a function that filters ModuleScript if it matches a
given name. Often paired with [`loadChildren`](load-children.md) and
[`loadDescendants`](load-descendants.md) as you will frequently filter by name.

=== "Luau"

    ```Lua
    function prvd.matchesName(
      name: string
    ): (ModuleScript) -> boolean
    ```

=== "TypeScript"

    ```TypeScript
    export const matchesName: (
      name: string
    ) => (module: ModuleScript) => boolean
    ```

---

## Parameters

### name `#!lua : string`

The name to filter with.

---

## Returns

A predicate function that filters module if it matches the name.

---

## Learn More

- [Ignition tutorial](../../../learn/ignition.md)
