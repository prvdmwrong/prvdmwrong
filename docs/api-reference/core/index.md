---
hide:
 - toc
---

<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

<section class="prvdmwrong-api-packagepage" markdown>

<section markdown>

<h1 class="prvdmwrong-api-top">
<span class="prvdmwrong-api-header"> Prvd 'M Wrong </span>
</h1>

Core Prvd 'M Wrong functionality including providers, lifecycles, and module roots along with built-in components and networking libraries.

## Providers

APIs for creating top level providers that *provide* specific functionality in
a game, along with creating starting roots for using providers.

<section class="prvdmwrong-api-items">
<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="providers/functions/prvd">prvd</a>
Construct and returns a new provider. Providers *provide* specific functionality in a game.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="providers/functions/root">root</a>
Construct and returns a new root. Roots are starting points for Prvd 'M Wrong games where providers can be bootstrapped.
</section>
</section>


</section>

## Lifecycles

APIs for creating custom provider lifecycle events. Providers with a lifecycle's specified method will register that lifecycle event.

<section class="prvdmwrong-api-items">
<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="lifecycles/functions/fireconcurrent">fireConcurrent</a>
Spawns all callbacks of a lifecycle asynchronously.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="lifecycles/functions/firesequential">fireSequential</a>
Calls all callbacks of a lifecycle sequentially.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="lifecycles/functions/lifecycle">lifecycle</a>
Constructs and returns a new lifecycle object. Providers with the specified method will be registered.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="lifecycles/functions/onlifecycledestroying">onLifecycleDestroying</a>
Called when a lifecycle is being destroyed. Listeners are expected to be infallible and non-yielding. The listener receives the lifecycle.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="lifecycles/functions/onregistered">onRegistered</a>
Called when an object registers a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
</section>
</section>

<section class="prvdmwrong-api-item">
<span class="prvdmwrong-api-itemkind"><span class="prvdmwrong-api-functionkind" title="Function">f</span></span>
<section class="prvdmwrong-api-iteminfo">
<a href="lifecycles/functions/onunregistered">onUnregistered</a>
Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
</section>
</section>


</section>


</section>

<section class="md-sidebar md-sidebar--secondary prvdmwrong-api-packagesidebar" markdown>

<section class="prvdmwrong-api-usewith" markdown>
<nav class="usage-instructions-nav">
Use with
<select id="usage-instructions-select">
<option value="wally">Wally</option>
<option value="pesde">Pesde</option>
<option value="npm">npm</option>
<option value="pnpm">pnpm</option>
<option value="yarn">Yarn</option>
</select>
</nav>
<section class="usage-instructions-package usage-instructions-wally">
<span class="usage-instructions-title">
Add to <code>wally.toml</code>
</span>

```TOML
prvd = "prvdmwrong/core@0.2"
```

<span class="usage-instructions-title">
Install packages
</span>

```Bash
wally install
```

<span class="usage-instructions-title">
Import package
</span>

```Luau
local prvd = require(ReplicatedStorage.Packages.prvd)
```

</section>
<section class="usage-instructions-package usage-instructions-pesde">
<span class="usage-instructions-title">
Install package
</span>

```Bash
pesde add prvdmwrong/core@0.2
```

<span class="usage-instructions-title">
Import package
</span>

```Luau
local prvd = require(ReplicatedStorage.packages.prvd)
```

</section>
<section class="usage-instructions-package usage-instructions-npm">
<span class="usage-instructions-title">
Install package
</span>

```Bash
npm i @prvdmwrong/core
```

<span class="usage-instructions-title">
Import package
</span>

```TypeScript
import * as prvd from "@prvdmwrong/core"
```

</section>
<section class="usage-instructions-package usage-instructions-pnpm">
<span class="usage-instructions-title">
Install package
</span>

```Bash
pnpm i @prvdmwrong/core
```

<span class="usage-instructions-title">
Import package
</span>

```TypeScript
import * as prvd from "@prvdmwrong/core"
```

</section>
<section class="usage-instructions-package usage-instructions-yarn">
<span class="usage-instructions-title">
Install package
</span>

```Bash
yarn add @prvdmwrong/core
```

<span class="usage-instructions-title">
Import package
</span>

```TypeScript
import * as prvd from "@prvdmwrong/core"
```

</section>

</section>
</section>

</section>
<script src="../../scripts/usewith.js"></script>
