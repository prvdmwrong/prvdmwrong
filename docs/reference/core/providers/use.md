<div class="ompdoc-api-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# use

Uses a provider within Oh My Prvd. During ignition, Oh My Prvd will inject the
dependencies your provider uses.

=== "Luau"

    ```Lua
    function prvd.use<T>(
      provider: Provider<T>
    ): T
    ```

=== "TypeScript"

    ```TypeScript
    export const use: <T extends object>(
      provider: Provider<T>
    ) => T
    ```

!!! danger "Do not use dependencies outside of lifecycle methods"

    Oh My Prvd only returns a shadow of the `use()`d provider. You *cannot* use
    it outside of lifecycle methods

    Behind the scenes, Oh My Prvd will keep track of what dependencies your
    provider uses, figure out the correct load order for you, and inject your
    dependencies.

    This is also why you can't freeze your provider tables - this prevents Oh My
    Prvd from modifying them, thus preventing dependency injection.

---

## Parameters

### provider `#!lua : Provider<T>`

The provider to use.

---

## Returns `#!lua : T`

The used provider. In reality, this returns a *shadow* of the provider, which
will be injected during ignition.

---

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
