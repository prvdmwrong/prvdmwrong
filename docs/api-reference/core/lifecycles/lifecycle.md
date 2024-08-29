<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Lifecycles</a>
</div>
<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">constructor</span>
<span class="pmwdoc-reference-since">since v0.2</span>
</div>

# :octicons-package-16: Lifecycle

Constructs and returns a new [lifecycle](../types/lifecycle.md) within Prvd 'M
Wrong. Lifecycles are special event dispatchers that can hook onto a provider's
method.

=== "Luau"

    ```Lua
    function prvd.Lifecycle(
      method: string,
      fire: (self: Lifecycle, ...unknown) -> ()
    ): Lifecycle
    ```

=== "TypeScript"

    ```TypeScript
    export function Lifecycle: (
      method: string,
      fire: (lifecycle: Lifecycle, ...args: unknown[]) => void
    ) => Lifecycle
    ```

---

## Parameters

### method `#!lua : string`

The provider method that this lifecycle should hook onto. During startup, Oh My
Prvd will register all lifecycles on a provider.

### fire `#!lua : (self: Lifecycle, ...unknown) -> ()`

A method to fire the lifecycle method. It receives itself and the arguments
passed to it. For convenience, Prvd 'M Wrong provides two methods you can use:

- [`fireConcurrent(self, ...)`](fire-concurrent.md) which spawns all listeners
  concurrently
- [`fireSequential(self, ...)`](fire-sequential.md) which runs all listeners
  sequentially

---

## Returns

[A freshly constructed lifecycle.](../types/lifecycle.md)

---

## Learn More

- [Lifecycles tutorial](../../../tutorials/fundamentals/lifecycles.md)
