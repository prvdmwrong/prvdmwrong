<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      useLifecycle
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
useLifecycle(
    root: Root, 
    lifecycle: Lifecycle
): Root
```

Uses the lifecycle as a dependency. When the root is started, all providers
with the lifecycle's method will have it registered.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    root: Root
  </span>
</h3>

The root that should use the lifecycle.
<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    lifecycle: Lifecycle
  </span>
</h3>

The lifecycle to be used.

## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    Root
  </span>
</h3>

The same root for convenience.
