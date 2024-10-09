<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      onUnregistered
    </span>
  </span>
  <span class="prvdmwrong-api-labels">
    <a class="prvdmwrong-api-source" href="https://github.com/prvdmwrong/prvdmwrong/blob/0.2/prvdmwrong/core/src/lifecycles.luau#L177" title="View source code on GitHub">
    view code
    </a>
  </span>
</h1>

<!-- Hack: TypeScript has better syntax highlighting than MkDocs flavored Luau lol -->
```TypeScript
onUnregistered(
	listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()
): () -> ()
```

Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()
  </span>
</h3>

Called when any lifecycle unregisters a callback.


## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    () -> ()
  </span>
</h3>

A callback that when called removes the listener.

