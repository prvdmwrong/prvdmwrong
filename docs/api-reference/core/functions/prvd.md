<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
  <span>
    <span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">
      function
    </span>
    <span class="prvdmwrong-api-header">
      prvd
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
prvd(
    provider: Self, 
    name: string?
): Provider<Self>
```

Construct and returns a new provider. Providers *provide* specific
functionality in a game.

Intended for use as a constructor for Luau projects. For Roblox TypeScript
projects, consider using Provider instead.

## Parameters

<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    provider: Self
  </span>
</h3>

The provider and associated properties itself.
<h3 class="prvdmwrong-api-param">
  <span class="prvdmwrong-api-type">
    name: string?
  </span>
</h3>



## Returns

<h3 class="prvdmwrong-api-return">
  <span class="prvdmwrong-api-type">
    Provider<Self>
  </span>
</h3>

A newly constructed provider.
