<!-- This file was @generated and should not be edited. -->
<!-- Run `lune run regen` to generate fresh documentation. -->

# Prvd

Prvd 'M Wrong is a Roblox game framework built with modern standards
delivering type-safe APIs, dependency resolution, and unparalleled DX. Zero
bloat, plugins, or lock-in required.

This package contains core Prvd 'M Wrong functionality including providers,
lifecycles, and game roots along with built-in components and networking.

```Luau
local PlayerProvider = {}
type Self = typeof(PlayerProvider)

function PlayerProvider.onInit(self: Self)
    self.playerAdded = prvd.lifecycle("onPlayerAdded", prvd.fireConcurrent)

    local function onPlayerAdded(newPlayer: Player)
        self.playerAdded:fire(newPlayer)
    end

    self.conn = Players.PlayerAdded:Connect(onPlayerAdded)
    for _, existingPlayer in Players:GetPlayers() do
        onPlayerAdded(newPlayer)
    end
end

function PlayerProvider.onStop(self: Self)
    self.playerAdded:destroy()
    self.conn:Disconnect()
end

return prvd(PlayerProvider)
```

<section class="prvdmwrong-api-items">
  <section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/provider">
      Provider
    </a>
    Construct and returns a new provider from a Roblox TypeScript class
declaration. Providers *provide* specific functionality in a game.

Intended for use as a class decorator for Roblox TypeScript projects. For
Luau projects, consider using prvd instead.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/fireconcurrent">
      fireConcurrent
    </a>
    Spawns all callbacks of a lifecycle asynchronously.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/firesequential">
      fireSequential
    </a>
    Calls all callbacks of a lifecycle sequentially.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/lifecycle">
      lifecycle
    </a>
    Constructs and returns a new lifecycle object. Providers with the specified method will be registered.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onlifecycleconstructing">
      onLifecycleConstructing
    </a>
    Called just before a constructing lifecycle is returned. The listener
callback receives the lifecycle that is constructing.

Listener callbacks are expected to be non-yielding and infallible.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onlifecycledestroying">
      onLifecycleDestroying
    </a>
    Called just before a lifecycle is destroyed. The listener callback receives
the lifecycle that is destroyed.

Listener callbacks are expected to be non-yielding and infallible.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onlifecycleregistered">
      onLifecycleRegistered
    </a>
    Called when an object registers a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onlifecycleunregistered">
      onLifecycleUnregistered
    </a>
    Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onlifecycleused">
      onLifecycleUsed
    </a>
    Called when a root uses a lifecycle. The listener callback receives the root
along with the used lifecycle
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onproviderconstructed">
      onProviderConstructed
    </a>
    Called just before a constructing provider is returned. The listener
callback receives the provider that is constructed.

Listener callbacks are expected to be non-yielding and infallible.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onproviderused">
      onProviderUsed
    </a>
    Called when a root uses a provider. The listener callback receives the root
along with the used provider
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onrootconstructed">
      onRootConstructed
    </a>
    Called just before a constructing root is returned. The listener callback
receives the root that is constructing.

Listener callbacks are expected to be non-yielding and infallible.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onrootstarted">
      onRootStarted
    </a>
    Called just before a root finishes starting. The listener callback receives
the root that is starting.

Listener callbacks are expected to be non-yielding and infallible.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/onsubrootused">
      onSubRootUsed
    </a>
    Called when a "parent" root uses a "sub" root. The listener callback
receives the root along with the used provider
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/prvd">
      prvd
    </a>
    Construct and returns a new provider. Providers *provide* specific
functionality in a game.

Intended for use as a constructor for Luau projects. For Roblox TypeScript
projects, consider using Provider instead.
  </section>
</section>
<section class="prvdmwrong-api-item">
  <span class="prvdmwrong-api-itemkind">
    <span class="prvdmwrong-api-functionkind" title="Function">
      f
    </span>
  </span>
  <section class="prvdmwrong-api-iteminfo">
    <a href="prvd/functions/root">
      root
    </a>
    Construct and returns a new root. Roots are starting points for Prvd 'M
Wrong games where providers can be bootstrapped.
  </section>
</section>

</section>
