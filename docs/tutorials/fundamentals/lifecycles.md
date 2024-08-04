# Lifecycles

Oh My Prvd provides the `:onInit()` and `:onStart()` lifecycle methods. To
tailor your needs, you implement custom lifecycle methods or import additional
lifecycle methods.

---

## Implement Your Own

You can implement your own lifecycle method. For this example, we will create
our own `:onPlayerAdded(player)` lifecycle method through the `Lifecycle`
object.

To use `Lifecycle` in your code, you first need to import it from the core
package, so that you can refer to it by name:

=== "Luau"

    ```Lua
    local Lifecycle = prvd.Lifecycle
    type Lifecycle<Interface> = prvd.Lifecycle<Interface>
    ```

=== "TypeScript"

    ```TypeScript
    import { Lifecycle, type Lifecycle } from "@rbxts/ohmyprvd"
    ```

Let's define an interface that will sastify our lifecycle:

=== "Luau"

    ```TypeScript
    type OnPlayerAdded = {
      onPlayerAdded: (self: unknown, Player) -> ()
    }
    ```

=== "TypeScript"

    ```TypeScript
    interface OnPlayerAdded {
      onPlayerAdded(player: Player) => void
    }
    ```

To create a new lifecycle object, call the `Lifecycle` object and give it a
method to track and a method to call when fired. It takes a parameter and
a variadic; for the first part of the tutorial, this will be unnamed:

=== "Luau"

    ```Lua
    local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", function(_, ...)

    end)
    ```

=== "TypeScript"

    ```TypeScript
    const playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", (_, _) => {

    })
    ```

To fire the lifecycle, call it's `:fire(...)` method, and pass arguments to call
its lifecycle method with:

=== "Luau"

    ```Lua
    Players.PlayerAdded:Connect(function(newPlayer)
      playerAdded:fire(newPlayer)
    end)
    for _, existingPlayer in ipairs(Players:GetPlayers()) do
      playerAdded:fire(existingPlayer)
    end
    ```

=== "TypeScript"

    ```TypeScript
    Players.PlayerAdded.Connect((newPlayer) => {
      playerAdded.fire(newPlayer)
    })
    for (const existingPlayer of Players:GetPlayers()) {
      playerAdded.fire(existingPlayer)
    }
    ```

Under the hood, Oh My Prvd will register all providers that specify an
`onPlayerAdded` method.

### Firing The Lifecycle

Our lifecycle does nothing when we fire it. The lifecycle constructor passes
itself as the first argument, to which you can access it's listeners:

=== "Luau"

    ```Lua
    local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", function(self, ...)
      for _, listener in ipairs(self.listeners) do
        task.spawn(listener.onPlayerAdded, listener)
      end
    end)
    ```

=== "TypeScript"

    ```TypeScript
    const playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", (lifecycle, _) => {
      for (const listener of lifecycle.listeners) {
        task.spawn(() -> listener.onPlayerAdded)
      }
    })
    ```

The variadic argument are the arguments passed when the lifecycle is fired. Try
asking for a `player` argument for this handler:

=== "Luau"

    ```Lua
    local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", function(self, player)
      for _, listener in ipairs(self.listeners) do
        task.spawn(listener.onPlayerAdded, listener, player)
      end
    end)
    ```

=== "TypeScript"

    ```TypeScript
    const playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", (lifecycle, ...args) => {
      for (const listener of lifecycle.listeners) {
        task.spawn(() -> listener.onPlayerAdded(args[0]))
      }
    })
    ```

Now, when a player joins the game, the lifecycle fires its listeners:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local MyProvider = {}
    function MyProvider:onPlayerAdded(player)
      print("Greetings", player)
    end

    return prvd.new("MyProvider", MyProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/ohmyprvd"
    export const MyProvider = Provider("MyProvider", {
      onPlayerAdded(player) {
        print("Greetings", player)
      }
    })
    ```

The PointsProvider from earlier can be rewritten to use it:

=== "Luau"

    ```Lua
    -- ...

    function PointsProvider.onStart(self: Self)
      Players.PlayerRemoving:Connect(function(player)
        self.points[player] = nil
      end)
    end

    function PointsProvider.onPlayerAdded(self: Self, newPlayer: Player)
      self:setDefaultPoints(newPlayer)
    end

    -- ...
    ```

=== "TypeScript"

    ```TypeScript
    export const PointsProvider = Provider("PointsProvider", {
      // ...
      onStart() {
        Players.PlayerRemoving.Connect((player) => {
          this.points.delete(player)
        })
      }

      onPlayerAdded(newPlayer: Player) {
        this.setDefaultPoints(newPlayer)
      }
      // ...
    })
    ```

### Preset Handlers

For convenience, Oh My Prvd exports two handlers you can use while constructing
lifecycles.

For lifecycles that do not depend on execution order, you can pass
`fireConcurrent` as the `fire` method. This will spawn all of the lifecycle
listeners as threads:

=== "Luau"

    ```Lua
    local fireConcurrent = prvd.fireConcurrent
    local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", fireConcurrent)
    ```

=== "TypeScript"

    ```TypeScript
    import { Lifecycle, fireConcurrent } from "@rbxts/ohmyprvd"
    const playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", fireConcurrent)
    ```

Contrast to `fireConcurrent`, for lifecycles that do depend on execution order,
you can pass `fireSequential` as the `fire` method. This will run all of the
lifecycle listeners synchronously:

=== "Luau"

    ```Lua
    local fireSequential = prvd.fireSequential
    local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", fireSequential)
    ```

=== "TypeScript"

    ```TypeScript
    import { Lifecycle, fireSequential } from "@rbxts/ohmyprvd"
    const playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", fireSequential)
    ```

!!! danger "Exercise error safety"

    `fireSequential` does not protect itself from errors. If a listener throws
    an error in its lifecycle method, it will halt further execution.

    Instead, write a handler that is protected from errors:

    === "Luau"

        ```Lua
        local playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", function(self, player)
          for _, listener in ipairs(self.listeners) do
            local ok, result = pcall(listener.onPlayerAdded, listener, player)
            if ok == false then
              warn(listener, "threw an error!", result)
            end
          end
        end)
        ```

    === "TypeScript"

        ```TypeScript
        const playerAdded: Lifecycle<OnPlayerAdded> = Lifecycle("onPlayerAdded", (lifecycle, player) => {
          for (const listener of lifecycle.listeners) {
            const [ok, result] = pcall(() => listener.onPlayerAdded(player))
            if (ok == false) {
              warn(listener, "threw an error!", result)
            }
          }
        })
        ```

---

## Additional Lifecycles

Creating additional lifecycle methods such as `:onPlayerAdded(player)` can be a
hassle. For this, Oh My Prvd exports additional lifecycle methods through a
separate `ohmyprvd-lifecycles` package, [which you will have to
install.](../installation.md)

Once installed, import the package, preferably within your startup script:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    require(ReplicatedStorage.Packages.ohmyprvdLifecycles)
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
