<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Internal</a>
</div>
<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">function</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-code-16: getMetadata

!!! warning "Under construction"
    This page is under construction - information may be incomplete or missing.

=== "Luau"

    ```Lua
    function prvd.getMetadata(
      object: unknown,
      key: string,
    ): unknown?
    ```

=== "TypeScript"

    ```TypeScript
    export const getMetadata: <T>(
      object: unknown,
      key: string
    ) => T | undefined
    export const deleteMetadata: (
      object: unknown,
      key: string,
      property?: string,
    ) => void
    ```

---

## Parameters

### object `#!lua : unknown`

### key `#!lua : string`

---

## Returns

The metadata value.
