<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      onLifecycleConstructing
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
onLifecycleConstructing(
    listener: (constructedLifecycle: Lifecycle<Args...>) -> ()
): () -> ()
```

Called just before a constructing lifecycle is returned. The listener
callback receives the lifecycle that is constructing.

Listener callbacks are expected to be non-yielding and infallible.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    listener: (constructedLifecycle: Lifecycle<Args...>) -> ()
  </span>
</h3>

Fired just before a construcing lifecycle is returned. The listener callback receives the lifecyle that is constructing.

## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    () -> ()
  </span>
</h3>

A callback that when called removes the listener.
