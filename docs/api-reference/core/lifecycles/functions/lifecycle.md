<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      lifecycle
    </span>
  </span>
  <span class="prvdmwrong-api-labels">
    <a class="prvdmwrong-api-source" href="https://github.com/prvdmwrong/prvdmwrong/blob/0.2/prvdmwrong/core/src/lifecycles.luau#L50" title="View source code on GitHub">
    view code
    </a>
  </span>
</h1>

<!-- Hack: TypeScript has better syntax highlighting than MkDocs flavored Luau lol -->
```TypeScript
lifecycle(
	method: string
	onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
): Lifecycle<Args...>
```

Constructs and returns a new lifecycle object. Providers with the specified method will be registered.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    method: string
  </span>
</h3>

The provider method that this lifecycle should hook onto.

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
  </span>
</h3>

A method to fire the lifecycle method. It receives itself and the arguments passed to it.


## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    Lifecycle<Args...>
  </span>
</h3>

A freshly constructed lifecycle object.

