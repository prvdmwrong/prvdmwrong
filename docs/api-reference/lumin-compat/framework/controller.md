<div class="pmwdoc-reference-header">
<h1>Controller</h1>
<span>available since <code>v0.2</code></span>
</div>

Constructs and returns a new [provider](../../core/types/provider.md) given a
Lumin Framework controller. The `name` field is preserved as the provider's
identifier.

=== "Luau"

    ```ts
    function Controller<Members>(
      name: string,
      members: Members
    ): prvd.Provider<Members>
    ```

=== "TypeScript"

    ```ts
    export const Controller: <Members>(
      name: string,
      members: Members
    ) => prvd.Provider<Members>
    ```

## Parameters

### name `#!lua : string`

The identifier to be used for the provider.

### members `#!lua : Members`

The members of this provider.

## Returns

A newly constructed provider preserving the following:

- the `name` field of the constructor is used as the identifier
- the `Init` method is mapped to `onInit`
- the `Start` method is mapped to `onStart`
