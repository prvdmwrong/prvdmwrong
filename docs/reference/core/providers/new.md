<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">constructor</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-package-16: new

=== "Luau"

    Constructs and returns a new Luau [provider](../types/provider.md) within Prvd
    'M Wrong. Providers must be created before calling `prvd.start(options)`.

    ```Lua
    function prvd.new<T>(
      provider: T
    ): Provider<T>
    ```

    !!! success "Shorthand syntax"

        It's recommended to call the package as a shorthand for `prvd.new`:

        ```Lua
        local prvd = -- Import Prvd 'M Wrong however you'd like!
        local MyProvider = {}
        return prvd(MyProvider)
        ```

    !!! warning "Beware the difference"

        Both `prvd.new` and `@Provider()` appeal for different environments.
        `prvd.new()` is used as a function to construct Luau providers. Contrast
        to `@Provider()`, which is used as a class decorator to construct
        TypeScript decorators.

---

## Parameters

### provider `#!lua : T`

The methods and properties of the provider. All lifecycle methods will be
registered during startup. The provider can specify a `name` property for debug
profiling, and falls back to using `debug.info`. The provider may also specify a
`loadOrder` property which dictates when the provider is loaded, and defaults to
one.

---

## Returns `#!lua : Provider<T>`

[A freshly registered provider.](../types/provider.md)

---

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
