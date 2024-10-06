<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
<span>
<span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">function</span>
<span class="prvdmwrong-api-header"> onLifecycleDestroying </span>
</span>
<span class="prvdmwrong-api-labels">
<span class="prvdmwrong-api-since", title="Since version 0.2">
since 0.2
</span>
<a class="prvdmwrong-api-source" href=https://github.com/prvdmwrong/prvdmwrong/tree/0.2/prvdmwrong/core/src/lifecycles.luau#L190 title="View source code on GitHub">
view source
</a>
</span>
</h1>

```Luau
function prvd.onLifecycleDestroying(
	listener: (destroyedLifecycle: Lifecycle<Args...>) -> ()
): () -> ()
```

Called when a lifecycle is being destroyed. Listeners are expected to be infallible and non-yielding. The listener receives the lifecycle.

---

## Parameters

<h3 class="prvdmwrong-api-param">
listener
<span class="prvdmwrong-api-type">: (destroyedLifecycle: Lifecycle<Args...>) -> () </span>
</h3>

Called when any lifecycle is being destroyed.

---

<h2 class="prvdmwrong-api-returns">
Returns
<span class="prvdmwrong-api-type">: () -> () </span>
</h2>

A callback that when called removes the listener.
