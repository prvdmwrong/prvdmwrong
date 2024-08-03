# Lifecycle Methods

Oh My Prvd provides the `:onInit()` and `:onStart()` lifecycle methods. To
tailor your needs, you implement custom lifecycle methods or import additional
lifecycle methods.

---

## Implement Your Own

You can implement your own lifecycle method. For this example, we will create
our own `:onPlayerAdded(player)` lifecycle method.

First, tell Oh My Prvd we will track providers which implement a `onPlayerAdded`
method:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.prvd)

    prvd.onMethodImplemented("onPlayerAdded", function(provider)
      -- TODO: implement this!
    end)
    ```

=== "TypeScript"

    ```TypeScript
    import { onMethodImplemented } from "@rbxts/ohmyprvd"

    onMethodImplemented("onPlayerAdded", (provider) => {
      // TODO: implement this!
    })
    ```

Let's add all providers which implement this method to a "watchlist", which we
will fire the lifecycle methods later:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.prvd)

    -- This interface satisfies our lifecycle method!
    type OnPlayerAdded = {
      onPlayerAdded: (self: prvd.Provider<unknown>, Player) -> ()
    }

    local playerAdded: { [prvd.Provider<OnPlayerAdded>]: true } = {}
    prvd.onMethodImplemented("onPlayerAdded", function(provider)
      playerAdded[provider] = true
    end)
    ```

=== "TypeScript"

    ```TypeScript
    import { type Provider, onMethodImplemented } from "@rbxts/ohmyprvd"

    // This interface satisfies our lifecycle method!
    interface OnPlayerAdded {
      onPlayerAdded(player: Player): void
    }

    const playerAdded = new Set<Provider<OnPlayerAdded>>()
    onMethodImplemented("onPlayerAdded", (provider) => {
      playerAdded.add(provider)
    })
    ```

Finally, we can iterate over this and fire our lifecycle method:

=== "Luau"

    ```Lua
    local function doPlayerAdded(newPlayer: Player)
      for provider in pairs(playerAdded) do
        task.spawn(provider.onPlayerAdded, provider, newPlayer)
      end
    end

    Players.PlayerAdded:Connect(doPlayerAdded)
    for _, existingPlayer in ipairs(Players:GetPlayers()) do
      doPlayerAdded(existingPlayer)
    end
    ```

=== "TypeScript"

    ```TypeScript
    function doPlayerAdded(newPlayer: Player) {
      for (const [provider] in pairs(playerAdded)) {
        task.spawn(() => provider.onPlayerAdded(newPlayer))
      }
    }

    Players.PlayerAdded.Connect(doPlayerAdded)
    for (const existingPlayer in Players.GetPlayers) {
      doPlayerAdded(existingPlayer)
    }
    ```

Now, other providers can hook onto our lifecycle method. We can refactor our
`PointsProvider` earlier to use it:

=== "Luau"

    ```Lua
    function PointsProvider.onPlayerAdded(self: typeof(PointsProvider), player: Player)
      self:setDefaultPoints(player)
    end
    ```

=== "TypeScript"

    ```TypeScript
    onPlayerAdded(player: Player) {
      this.setDefaultPoints(player)
    }
    ```

---

## Additional Lifecycles

Implementing additional lifecycle methods such as `:onPlayerAdded(player)` can
be a hassle. For this, Oh My Prvd exports additional lifecycle methods through a
separate `ohmyprvd-lifecycles` package, [which you will have to
install.](../installation.md)

Once installed, import the package, preferably within your startup script:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    -- this assumes you've aliased the package as `lifecycles`
    local lifecycles = require(ReplicatedStorage.Packages.lifecycles)
    ```

=== "TypeScript"

    ```TypeScript
    import "@rbxts/ohmyprvd-lifecycles"
    ```

This package exports nothing. Instead, it registers a separate provider that
implements a host of lifecycle events during runtime:

- `:onPostSimulation(dt)`, `:onPreSimulation(dt)`, and `:onPreRender(dt)` lets you
  hook onto RunService's runtime events:
      - `:onPostSimulation(dt)` runs every `RunService.PostSimulation` and is
        optimal for responding to changes in the physics state.
      - `:onPreSimulation(dt)` runs every `RunService.PreSimulation` and is
        optimal for manipulating physics.
      - `:onPreRender(dt)` runs every `RunService.PreRender`. Notably, this only
        runs on the client.
- `:onShutdown` hooks onto `game:BindToClose`, or `plugin.Unloading` if ran
  under a plugin environment. `:onShutdown` also cleanups built-in lifecycle
  methods, preventing memory leaks especially for a plugin. It's great for doing
  post-mortem cleanup once the game closes or your plugin is unloaded.
- `:onPlayerAdded(player)` and `:onPlayerRemoving(player)` binds to
  Players.PlayerAdded and Players.PlayerRemoving respectively, making it ideal
  for tracking players.
