<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<h1 class="prvdmwrong-api-top">
<span>
<span class="prvdmwrong-api-kind prvdmwrong-api-functionkind">function</span>
<span class="prvdmwrong-api-header"> lifecycle </span>
</span>
<span class="prvdmwrong-api-labels">
<span class="prvdmwrong-api-since", title="Since version 0.2">
since 0.2
</span>
<a class="prvdmwrong-api-source" href=https://github.com/prvdmwrong/prvdmwrong/tree/0.2/prvdmwrong/core/src/lifecycles.luau#L45 title="View source code on GitHub">
view source
</a>
</span>
</h1>

```Luau
function prvd.lifecycle(
	method: string
	onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
): Lifecycle<Args...>
```

Constructs and returns a new lifecycle object. Providers with the specified method will be registered.

---

## Parameters

<h3 class="prvdmwrong-api-param">
method
<span class="prvdmwrong-api-type">: string </span>
</h3>

The provider method that this lifecycle should hook onto.

<h3 class="prvdmwrong-api-param">
onFire
<span class="prvdmwrong-api-type">: (lifecycle: Lifecycle<Args...>, Args...) -> () </span>
</h3>

A method to fire the lifecycle method. It receives itself and the arguments passed to it.

---

<h2 class="prvdmwrong-api-returns">
Returns
<span class="prvdmwrong-api-type">: Lifecycle<Args...> </span>
</h2>

A freshly constructed lifecycle object.
