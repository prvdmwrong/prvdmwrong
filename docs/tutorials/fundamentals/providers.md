# Providers

Oh My Prvd allows you to define providers for your game logic. These *provide*
specific functions within your game, e.g. you might create a `SaveDataProvider`
to manage save files or a `CameraProvider` to handle player camera movement.

---

## Structure

This is the minimum structure of a provider, which can be used and hook onto
lifecycle events:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    return prvd.new("PointsProvider", PointsProvider)
    ```

    For consistency, we recommend using `Provider` when favorable.

The `name` argument signifies what to identify your provider as. This name must
be unique from all other providers. Ideally, you should name your variable the
same as the service name, e.g. `#!lua local PointsProvider` would mean `#!lua
prvd.new("PointsProvider", ...)`.

Notice that you're creating the provider at the bottom of a file, and then
returning it. This lets Oh My Prvd to strictly type your provider, something
which will be important later.

---

## Methods, Properties, The Likes

Providers are just tables at the end of the day. As such, it's easy to add
methods, properties, and the likes to providers.

Let's add a `points` property to our `PointsProvider`, which will be a map of
a `Player` and their points:

=== "Luau"

    ```Lua hl_lines="5"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

    ```Lua hl_lines="7-15"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    PointsProvider.points = {}

    function PointsProvider.setDefaultPoints(
      self: typeof(PointsProvider),
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

Take a step back, and review what we wrote.

Notice in our `setDefaultPoints`, we require the first argument to be `self`,
which is `typeof` our `PointsProvider`.

This allows Luau to provide useful type information. Notice how if we omit the
`self` argument and use a colon `:` for our method, we lose typings for `self`:

```Lua
function PointsProvider:setDefaultPoints(
  player: Player
)
  -- self.points is typed as `a`, which is not very helpful!
  if self.points[player] ~= nil then
    return
  end
  self.points[player] = 10
end
```

Contrast as to if we typed `self` as a parameter:

```Lua hl_lines="2"
function PointsProvider.setDefaultPoints(
  self: typeof(PointsProvider),
  player: Player
)
  -- self.points is helpfully typed as `{| [Player]: number |}`!
  if self.points[player] ~= nil then
    return
  end
  self.points[player] = 10
end
```

`typeof(PointsProvider)` is not very concise. Let's make a type alias,
appropriately named `Self`:

```Lua
-- use just typeof()...
type Self = typeof(PointsProvider)
-- ...or wrap it inside prvd.Provider
type Self = prvd.Provider<typeof(PointsProvider)>
```

Both types are good, pick your poison and run with it.

We could then easily type `self` as such:

```Lua hl_lines="2"
function PointsProvider.setDefaultPoints(
  self: Self,
  player: Player
)
```

Now, our code can use `self` as a shorthand for the `PointsProvider`, while
other snippets of code could use our method through one of the following:

```Lua
-- pass self directly as an argument...
PointsProvider.setDefaultPoints(PointsProvider, player)
-- ...or let Luau pass self for us!
PointsProvider:setDefaultPoints(player)
```

---

## Lifecycle Methods

Providers and the likes can implement lifecycle methods, by having a method
that matches its lifecycle name.

Oh My Prvd provides two lifecycle events out of the box:

- `:onInit()` runs sequentially before any other lifecycle methods, methods are
  expected to be infallible and preferably non-yielding.
      - If you return a promise, Oh My Prvd will wait for the promise to resolve.
          Anything with an `:andThen` method and an `:awaitStatus` method will be
          picked up by Oh My Prvd.
- In contrast, `:onStart()` runs concurrently *after* all other lifecycle
  methods have been registered. This means failures and yields do not affect
  other providers.

Let's implement the `:onStart()` lifecycle, where we will set default points for
every player that joins:

=== "Luau"

    ```Lua hl_lines="2 19-28"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local PointsProvider = {}
    type Self = typeof(PointsProvider)
    PointsProvider.points = {}

    function PointsProvider.setDefaultPoints(
      self: Self,
      player: Player
    )
      if self.points[player] ~= nil then
        return
      end
      self.points[player] = 10
    end

    function PointsProvider.onStart(
      self: Self
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

---

## Memory

Now we have a problem: theres a [memory
leak](https://en.wikipedia.org/wiki/Memory_leak).

When we set points for a player, we add the player to the table. What happens
when the player leaves? Nothing. Which is an issue.

That player's data is forever held onto within the `points` table. We need to
clear out that data when the player leaves. Let's hook up our `:start` method
with the `Players.PlayerRemoving` event and remove their points:

```Lua hl_lines="27-29"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local prvd = require(ReplicatedStorage.Packages.ohmyprvd)
local Players = game:GetService("Players")

local PointsProvider = {}
PointsProvider.points = {}

function PointsProvider.setDefaultPoints(
  self: typeof(PointsProvider),
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
  Players.PlayerRemoving:Connect(function(player)
    self.points[player] = nil
  end)
end

return prvd.Provider("PointsProvider", PointsProvider)
```

---

## Dependencies

Often, providers may depend on other providers, such as a `CombatProvider`
requiring the player's `CharacterProvider`. Oh my Prvd lets you use providers
through dependency injection.

First, create a file for a new `MathProvider` with the following:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local MathProvider = {}

    function MathProvider.add(
      self: typeof(MathProvider),
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

```Lua hl_lines="3 8 34-43"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MathProvider = require(script.Parent.MathProvider)
local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

local PointsProvider = {}
PointsProvider.points = {}
PointsProvider.mathProvider = prvd.use(MathProvider)

function PointsProvider.setDefaultPoints(
  self: typeof(PointsProvider),
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

??? danger "Do not use dependencies outside of lifecycle methods!"

    Oh My Prvd only returns a shadow of the `use()`d provider. You *cannot* use
    it outside of lifecycle methods.

    Behind the scenes, Oh My Prvd will keep track of what dependencies your
    provider uses, figure out the correct load order for you, and inject your
    dependencies.

    This is also why you can't freeze your provider tables - Oh My Prvd will
    have to modify them.

---

## Congratulations

You just successfully wrote your first provider using Oh My Prvd!

That was a taste of Oh My Prvd. Later on, you will learn how to register your
own lifecycle methods, use Oh My Prvd networking primitives, and creating your
own components.

You can find the completed modules for MathProvider and PointsProvider in [the
`examples` directory.](https://github.com/team-fireworks/ohmyprvd/tree/main/examples)

Once you're comfortable writing providers, you are ready to take on the rest of
what Oh My Prvd offers.
