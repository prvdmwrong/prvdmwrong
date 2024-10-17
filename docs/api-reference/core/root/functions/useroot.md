<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      useRoot
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
useRoot(
    root: Root, 
    subRoot: Root
): Root
```

Uses the given "sub" root to be started when the "parent" root is started.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    root: Root
  </span>
</h3>

The "parent" root that should use the root.
<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    subRoot: Root
  </span>
</h3>

The "sub" root that should be queued.

## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    Root
  </span>
</h3>

The same "parent" root for convenience.
