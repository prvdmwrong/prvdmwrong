<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# preload

Preload the specified parent by requiring all `ModuleScripts` within it. An
optional `predicate` function can be provided to filter modules.

=== "Luau"

    ```Lua
    function prvd.loadChildren(
      parent: { Instance },
      predicate: ((ModuleScript) -> boolean)?
    ): { unknown }
    ```

=== "TypeScript"

    ```TypeScript
    export const preload: (
      parent: Instance[],
      predicate?: (module: ModuleScript) => boolean
    ) => unknown[]
    ```

---

## Parameters

### parent `#!lua : { Instance }`

An array of instances to load from. Often paired with `:GetChildren()` or
`:GetDescendants()`.

### predicate `#!lua : (ModuleScript) -> boolean`

An optional predicate function that will be called to filter the modules to load
with.

---

## Learn More

- [Startup tutorial](../../../tutorials/fundamentals/startup.md)
