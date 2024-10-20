<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      useModule
    </span>
  </span>
  <span class="prvdmwrong-api-labels">
    <a class="prvdmwrong-api-source" href="$source_url" title="View source code on GitHub">
    view code
    </a>
  </span>
</h1>

<!-- Hack: TypeScript has better syntax highlighting than MkDocs flavored Luau lol -->

```TypeScript
useModule(
    root: Root, 
    module: ModuleScript
): Root
```

Requires a ModuleScript and adds the returned provider to the root, if any.
If the provider is unnamed, the provider is named after the ModuleScript
name.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    root: Root
  </span>
</h3>

The root that should use the ModuleScript.
<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    module: ModuleScript
  </span>
</h3>

The ModuleScript that should be required.

## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    Root
  </span>
</h3>

The same root for convenience.
