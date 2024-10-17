<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      onProviderUsed
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
onProviderUsed(
    listener: (root: Root, provider: Provider<unknown>) -> ()
): () -> ()
```

Called when a root uses a provider. The listener callback receives the root
along with the used provider

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    listener: (root: Root, provider: Provider<unknown>) -> ()
  </span>
</h3>

Fired when a root uses a provider. The listener callback receives the root along with the used provider

## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    () -> ()
  </span>
</h3>

A callback that when called removes the listener.
