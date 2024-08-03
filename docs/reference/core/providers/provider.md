<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span>decorator</span>
<span>since v0.2</span>
</div>

# prvd.Provider

Constructs and returns a new class decorator that registers a
[provider](../types/provider.md) within Oh My Prvd. Providers must be created
before calling `prvd.start(options)`.

```TypeScript
export const Provider: (options?: {
  loadOrder?: number
}) => <T extends new () => InstanceType<T>>(provider: T) => void
```

!!! warning "Know the difference"

    This and [`prvd.new(name, provider)`](new.md) seems to serve the same
    purpose. This is used as a class decorator, ideal for Roblox TypeScript.
    Contrast to [`prvd.new(name, provider)`](new.md), which ideal to be used as
    a function for Luau.

---

## Parameters

### options `#!TypeScript : string`

Options to instantiate the provider with:

- `#!TypeScript loadOrder : number` can be specified as a shorthand for adding a
  loadOrder field.

---

## Returns `#!TypeScript : <...>(provider: T) => void`

A decorator that, when used on a class, registers it as a
[provider](../types/provider.md) within Oh My Prvd.

Note that the identifier is inferred from it's `__tostring` metamethod, which
should be appended by the Roblox TypeScript compiler.

---

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
