<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Lifecycles</a>
</div>
<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">function</span>
<span class="pmwdoc-reference-since">since v0.2</span>
</div>

# :octicons-package-16: fireSequential

A function that runs all listeners of a [lifecycle](../types/lifecycle.md) in
order synchronously. Intended to be used as the `fire` argument of the
[lifecycle](../types/lifecycle.md) constructor.

=== "Luau"

    ```Lua
    function prvd.fireSequential(
      self: Lifecycle,
      ...: unknown
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export function fireSequential: (
      lifecycle: Lifecycle,
      ...args: unknown[]
    ) => void
    ```

## Parameters

### self `#!lua : Lifecycle`

The lifecycle object that should have its listeners ran.

### ... `#!lua : unknown`

Arguments to call the listeners' method.

## Learn More

- [Lifecycles tutorial](../../../tutorials/fundamentals/lifecycles.md)
