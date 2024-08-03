<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# prvd.new

Constructs and returns a new [provider](../types/provider.md) within Oh My Prvd. Providers must be
created before calling `prvd.start(options)`.

```Lua
function prvd.new<T>(
  name: string,
  provider: T
): Provider<T>
```

!!! warning "Know the difference"

    This and [`@Provider(options)`](provider.md) seems to serve the same
    purpose. This is used as a function, ideal for Luau. Contrast to
    [`@Provider(options)`](provider.md), which ideal to be used as a class
    decorator for Roblox TypeScript.

---

## Parameters

### name `#!lua : string`

A unique name to identify the provider with. This will be used for debugging.

### provider `#!lua : T`

The methods and properties of the provider. Oh My Prvd provides two lifecycle
methods out of the box which may be specified:

- `:onInit` runs sequentially before any other lifecycle methods, methods are
  expected to be infallible and preferably non-yielding.
- `:onStart` runs concurrently *after* all other lifecycle methods have been
  registered. This means failures and yields do not affect other providers.

In addition, the provider may also specify a `loadOrder` property which
dictates when the provider is loaded, defaults to one.

---

## Returns `#!lua : Provider<T>`

A freshly registered provider.

---

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
