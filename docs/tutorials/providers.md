# Providers

Oh My Prvd allows you to define providers for your game logic. These *provide*
specific functions within your game, e.g. you might create a `SaveDataProvider`
to manage save files or a `CameraProvider` to handle player camera movement.

## Structure

This is the minimum structure of a provider, which can be used and hook onto
lifecycle events:

=== "Luau"

    ```Lua
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    return prvd.Provider("PointsProvider", PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/ohmyprvd"

    export = Provider("PointsProvider", {})
    ```

??? tip "Too verbose?"

    If writing `prvd.Provider` sounds verbose for you, Oh My Prvd aliases the
    `Provider` constructor with `.new`.

    ```Lua
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    return prvd.new("PointsProvider", PointsProvider)
    ```

    For consistency, we recommend using `Provider` when favorable.

The `name` argument signifies what to identify your provider as. This name must
be unique from all other providers. Ideally, you should name your variable the
same as the service name, e.g. `#!lua local PointsProvider` would mean
`#!lua prvd.create("PointsProvider", ...)`.

Notice that you're creating the provider at the bottom of a file, and then
returning it. This lets Oh My Prvd to strictly type your provider, something
which will be important later.

## Methods, Properties, The Likes

Providers are just tables at the end of the day. As such, it's dead easy to add
methods, properties, and the likes to providers.

Let's add a `points` property to our `PointsProvider`, which will be a map of
a `Player` and their points:

=== "Luau"

    ```Lua hl_lines="4"
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    PointsProvider.points = {}

    return prvd.Provider("PointsProvider", PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="4"
    import { Provider } from "@rbxts/ohmyprvd"

    export = Provider("PointsProvider", {
      points: Map<Player, number> = {}
    })
    ```

To instantiate our `points`, let's also implement a `setDefaultPoints` method
for convenience:

=== "Luau"

    ```Lua hl_lines="6-14"
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    PointsProvider.points = {}

    function PointsProvider.setDefaultPoints(
      self: typeof(PointsProvider)
      player: Player
    )
      if self.points[player] ~= nil then
        return
      end
      self.points[player] = 10
    end

    return prvd.Provider("PointsProvider", PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="6-8"
    import { Provider } from "@rbxts/ohmyprvd"

    export = Provider("PointsProvider", {
      points: Map<Player, number> = {}

      setDefaultPoints(player: Player) {
        this.points.get(player)?.set(10)
      }
    })
    ```

Notice we are passing `self` as an argument to our methods, which is of type
`typeof(PointsProvider)`. This allows internal code to use `self` as a shorthand
for the PointsProvider, with `self` fully typed, while external code can use the
colon syntax. Both of these are equivalent:

```Lua
PointsProvider.setDefaultPoints(PointsProvider, player)
PointsProvider:setDefaultPoints(player)
```

## Lifecycle Methods

Providers and the likes can implement lifecycle methods, by having a method
that matches its lifecycle name.

Oh My Prvd provides a few lifecycle events out of the box:

- `:init` runs sequentially before any other lifecycle methods, methods are
  expected to be infallible and preferably non-yielding.
- `:start` runs concurrently *after* all other lifecycle methods have been
  registered. This means failures and yields do not affect other providers.
- `:heartbeat` is ran every `RunService.HeartBeat` and is optimal for responding
  to changes in the physics state.
- `:step` is ran every `RunService.Stepped` and is optimal for manipulating
  physics.
- `:render` is ran every `RunService.RenderStepped`. Notably, this lifecycle
  event only runs on the client.

In order to maintain this pattern, be sure to set up your provider in the
`:init` method (or earlier; just in the module itself). By the time `:start`
methods are fired, other providers should be available for use.

As a rule of thumb, prefer to implement `:start` unless you need the unique
behavior of `:init`.

Speaking of which, let's implement a `:start` method to our `PointsProvider`,
which will add the player to our points table, and set it to a default value:

=== "Luau"

    ```Lua hl_lines="2 17-26"
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)
    local Players = game:GetService("Players")

    local PointsProvider = {}
    PointsProvider.points = {}

    function PointsProvider.setDefaultPoints(
      self: typeof(PointsProvider)
      player: Player
    )
      if self.points[player] ~= nil then
        return
      end
      self.points[player] = 10
    end

    function PointsProvider.start(
      self: typeof(PointsProvider)
    )
      Players.PlayerAdded:Connect(function(newPlayer)
        self:setDefaultPoints(newPlayer)
      end)
      for _, existingPlayer in pairs(Players:GetPlayers()) do
        self:setDefaultPoints(existingPlayer)
      end
    end

    return prvd.Provider("PointsProvider", PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="2 11-18"
    import { Provider } from "@rbxts/ohmyprvd"
    import { Players } from "@rbxts/services"

    export = Provider("PointsProvider", {
      points: Map<Player, number> = {},

      setDefaultPoints(player: Player) {
        this.points.get(player)?.set(10)
      }

      start() {
        Players.PlayerAdded.Connect((newPlayer) => {
          this.setDefaultPoints(newPlayer)
        })
        for (const existingPlayer in Players.GetPlayers()) {
          this.setDefaultPoints(existingPlayer)
        }
      }
    })
    ```

## Memory

Now we have a problem: theres a [memory
leak](https://en.wikipedia.org/wiki/Memory_leak).

When we set points for a player, we add the player to the table. What happens
when the player leaves? Nothing. Which is an issue.

That player's data is forever held onto within the `points` table. We need to
clear out that data when the player leaves. Let's hook up our `:start` method
with the `Players.PlayerRemoving` event and remove their points:

```Lua hl_lines="26-28"
local prvd = require(ReplicatedStorage.Packages.ohmyprvd)
local Players = game:GetService("Players")

local PointsProvider = {}
PointsProvider.points = {}

function PointsProvider.setDefaultPoints(
  self: typeof(PointsProvider)
  player: Player
)
  if self.points[player] ~= nil then
    return
  end
  self.points[player] = 10
end

function PointsProvider.start(
  self: typeof(PointsProvider)
)
  Players.PlayerAdded:Connect(function(newPlayer)
    self:setDefaultPoints(player)
  end)
  for _, existingPlayer in pairs(Players:GetPlayers()) do
    self:setDefaultPoints(existingPlayer)
  end
  Players.PlayerRemoving:Connect(function(player)
    self.points[player] = nil
  end)
end

return prvd.Provider("PointsProvider", PointsProvider)
```

## Dependencies

Often, providers may depend on other providers, such as a `CombatProvider`
requiring the player's `CharacterProvider`. Oh my Prvd lets you use providers
through dependency injection.

First, create a file for a new `MathProvider` with the following:

=== "Luau"

    ```Lua
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local MathProvider = {}

    function MathProvider.add(
      self: typeof(PointsProvider),
      a: number,
      b: number
    ): number
      -- this method is very expensive!
      task.wait(5)
      return a + b
    end

    return prvd.Provider("MathProvider", MathProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/ohmyprvd"

    export = Provider("MathProvider", {
      add(a: number, b: number) {
        // this method is very expensive!
        task.wait(5)
        return a + b
      }
    })
    ```

Then, from `PointsProvider`, import your newly created `MathProvider`:

```Lua
local MathProvider = require(script.Parent.MathProvider)
```

Finally, just specify your provider `use()`s another provider:

```Lua hl_lines="32-41"
local prvd = require(ReplicatedStorage.Packages.ohmyprvd)
local MathProvider = require(script.Parent.MathProvider)
local Players = game:GetService("Players")

local PointsProvider = {}
PointsProvider.points = {}

function PointsProvider.setDefaultPoints(
  self: typeof(PointsProvider)
  player: Player
)
  if self.points[player] ~= nil then
    return
  end
  self.points[player] = 10
end

function PointsProvider.start(
  self: typeof(PointsProvider)
)
  Players.PlayerAdded:Connect(function(newPlayer)
    self:setDefaultPoints(player)
  end)
  for _, existingPlayer in pairs(Players:GetPlayers()) do
    self:setDefaultPoints(existingPlayer)
  end
  Players.PlayerRemoving:Connect(function(player)
    self.points[player] = nil
  end)
end

function PointsProvider.addPoints(
  self: typeof(PointsProvider),
  player: Player,
  points: number
)
  self.points[player] = self.mathProvider:add(
    self.points[player],
    points
  )
end

return prvd.Provider("PointsProvider", PointsProvider)
```

!!! danger "Do not use dependencies outside of lifecycle methods!"

    Oh My Prvd only returns a shadow of the `use()`d provider. You *cannot* use
    it outside of lifecycle methods:

    ```Txt
    [ohmyprvd error(usedBeforeIgnition)]: cannot use provider "MathProvider" prior to ignition
      help: ohmyprvd will inject the dependency for you during runtime, its safe to use the provider inside a lifecycle method
      more info: team-fireworks.github.io/ohmyprvd/latest/api-reference/general/error-messages#usedbeforeignition
      stack trace:
        ohmyprvd.log:118 function throw
        ohmyprvd.prvd:181 function use
        PointsService:42
    ```

    Behind the scenes, Oh My Prvd will keep track of what dependencies your
    provider uses, figure out the correct load order for you, and inject your
    dependencies.

    This is also why you can't freeze your provider tables - Oh My Prvd will
    have to modify them.

**Congratulations! You just successfully wrote your first provider using Oh My Prvd!**

That was a taste of Oh My Prvd. Later on, you will learn how to register your
own lifecycle methods, use Oh My Prvd networking primitives, and creating your
own components.

Once you're comfortable writing providers, you are ready to take on the rest of
what Oh My Prvd offers.
