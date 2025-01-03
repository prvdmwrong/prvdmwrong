<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      fireSequential
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
fireSequential(
    lifecycle: Lifecycle<Args...>, 
    ...: Args...
): ()
```

Calls all callbacks of a lifecycle sequentially.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    lifecycle: Lifecycle<Args...>
  </span>
</h3>

Lifecycle to call callbacks with.
<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    ...: Args...
  </span>
</h3>

Arguments to call the callbacks with.

## Returns
