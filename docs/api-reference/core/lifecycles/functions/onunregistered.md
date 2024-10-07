<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
<span>
<span class="prvdmwrong-api-header"> onUnregistered </span>
</span>
<span class="prvdmwrong-api-labels">
<span class="prvdmwrong-api-since", title="Available since version 0.2">
since 0.2
</span>
<a class="prvdmwrong-api-source" href=https://github.com/prvdmwrong/prvdmwrong/tree/0.2/prvdmwrong/core/src/lifecycles.luau#L172 title="View source code on GitHub">
view code
</a>
</span>
</h1>

```Luau
function prvd.onUnregistered(
	listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()
): () -> ()
```

Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.

## Parameters

<h3 class="prvdmwrong-api-param">
listener
<span class="prvdmwrong-api-type">: (lifecycle: Lifecycle&lt;Args...&gt;, callback: (Args...) -&gt; ()) -&gt; () </span>
</h3>

Called when any lifecycle unregisters a callback.

## Returns

<h3 class="prvdmwrong-api-returns">
<span class="prvdmwrong-api-type"> () -&gt; () </span>
</h3>

A callback that when called removes the listener.
