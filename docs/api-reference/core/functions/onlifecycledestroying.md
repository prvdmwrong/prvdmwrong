<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      onLifecycleDestroying
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
onLifecycleDestroying(
    listener: (destroyedLifecycle: Lifecycle<Args...>) -> ()
): () -> ()
```

Called just before a lifecycle is destroyed. The listener callback receives
the lifecycle that is destroyed.

Listener callbacks are expected to be non-yielding and infallible.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    listener: (destroyedLifecycle: Lifecycle<Args...>) -> ()
  </span>
</h3>

Fired just before any lifecycle is being destroyed. The listener callbacj receives the lifecycle that is being destroyed.

## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    () -> ()
  </span>
</h3>

A callback that when called removes the listener.
