<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# getMetadata

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
