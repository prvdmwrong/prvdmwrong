<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">constructor</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-package-16: Provider

Returns a decorator that when applied to a TypeScript class registers it as a
[provider](../types/provider.md) within Prvd 'M Wrong. Providers must be created
before calling `prvd.start(options)`.

=== "TypeScript"

    ```TypeScript
    export const Provider: (
      options?: {
        loadOrder?: number
      }
    ) => <T extends new () => InstanceType<T>>(
      provider: T
    ) => void
    ```

    !!! tip "Name is inferred"

        Prvd 'M Wrong will infer the name of the class provider for memory
        profiling.

    !!! warning "Beware the difference"

        Both `prvd.new` and `@Provider()` appeal for different environments.
        `prvd.new()` is used as a function to construct Luau providers. Contrast
        to `@Provider()`, which is used as a class decorator to construct
        TypeScript decorators.

## Parameters

### options `#!ts : { loadOrder?: number }`

Additional options that will be applied onto the provider. It is recommended to
specify `loadOrder` through this argument.

## Returns `#!ts : <T extends new () => InstanceType<T>>(provider: T) => void`

A decorator that when used on a TypeScript class registers [a freshly
constructed provider.](../types/provider.md)

## Learn More

- [Providers tutorial](../../../tutorials/fundamentals/providers.md)
