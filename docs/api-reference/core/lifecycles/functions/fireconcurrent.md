<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
<span>
<span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">function</span>
<span class="prvdmwrong-api-header"> fireConcurrent </span>
</span>
<span class="prvdmwrong-api-labels">
<span class="prvdmwrong-api-since", title="Since version 0.2">
since 0.2
</span>
<a class="prvdmwrong-api-source" href=https://github.com/prvdmwrong/prvdmwrong/tree/0.2/prvdmwrong/core/src/lifecycles.luau#L132 title="View source code on GitHub">
view source
</a>
</span>
</h1>

```Luau
function prvd.fireConcurrent(
	lifecycle: Lifecycle<Args...>
	...: Args...
): ()
```

Spawns all callbacks of a lifecycle asynchronously.

---

## Parameters

<h3 class="prvdmwrong-api-param">
lifecycle
<span class="prvdmwrong-api-type">: Lifecycle<Args...> </span>
</h3>

Lifecycle to spawn callbacks with.

<h3 class="prvdmwrong-api-param">
...
<span class="prvdmwrong-api-type">: Args... </span>
</h3>

Arguments to call the callbacks with.

