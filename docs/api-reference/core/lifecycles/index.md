<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

# Lifecycles

APIs for creating custom provider lifecycle events. Providers with a lifecycle's specified method will register that lifecycle event.

<section class="prvdmwrong-api-items">
<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="./functions/fireconcurrent">fireConcurrent</a>
Spawns all callbacks of a lifecycle asynchronously.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="./functions/firesequential">fireSequential</a>
Calls all callbacks of a lifecycle sequentially.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="./functions/lifecycle">lifecycle</a>
Constructs and returns a new lifecycle object. Providers with the specified method will be registered.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="./functions/onlifecycledestroying">onLifecycleDestroying</a>
Called when a lifecycle is being destroyed. Listeners are expected to be infallible and non-yielding. The listener receives the lifecycle.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="./functions/onregistered">onRegistered</a>
Called when an object registers a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="./functions/onunregistered">onUnregistered</a>
Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
</section>
</section>


</section>
