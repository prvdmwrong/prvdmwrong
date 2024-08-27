# Providers

Prvd 'M Wrong allows you to define providers for your game logic. These *provide*
specific functions within your game, e.g. you might create a `SaveDataProvider`
to manage save files or a `CameraProvider` to handle player camera movement.

---

## Structure

This is the minimum structure of a provider, which can be used and hook onto
lifecycle events:

=== "Luau"

    ```Lua
    local prvd = -- Import Prvd 'M Wrong however you'd like!

    local PointsProvider = {}
    return prvd(PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/prvdmwrong"

    @Provider()
    export class Provider {}
    ```

??? success "Return with `prvd()`"

    Modules should return the constructed provider from `prvd()`. This allows
    Luau to infer the full, complete type of the provider:

    ```Lua
    local PointsProvider = {}
    return prvd(PointsProvider)
    ```

    Avoid creating a new provider earlier - Luau will not pick up additional
    fields, and will throw a type error as you're adding into a sealed table:

    ```Lua
    -- Don't do this!
    local PointsProvider = prvd({})

    function PointsProvider:onStart()
      -- ... snip ...
    end

    return PointsProvider
    ```

    Following this syntax, avoid constructing your provider inside the `prvd()`
    call, as Luau can't infer `self` properly:

    ```Lua
    -- Don't do this!
    return prvd {
      onStart = function(self)
        -- `self` is inferred as `a` here... not very useful!
      end
    }
    ```

??? tip "Know the difference"

    Both `prvd` and `@Provider()` appeal for different environments. `prvd()`
    is used as a function to construct Luau providers. Contrast to
    `@Provider()`, which is used as a class decorator to construct TypeScript
    decorators.

    Prvd 'M Wrong only exports one or the other for both environments,
    preventing you from using `prvd()` or `@Provider()` in the wrong
    environment.

For Luau providers, a `name` property can be specified which will be used for
memory profiling, and falls back to the current script running. Names are
inferred for TypeScript providers.

```Lua
local PointsProvider = {}
PointsProvider.name = "PointsProvider"
```

Notice that you're creating the provider at the bottom of a file, and then
returning it. This lets Prvd 'M Wrong to strictly type your provider, something
which will be important later.

---

## Methods, Properties, The Likes

Providers are just tables at the end of the day. As such, it's easy to add
methods, properties, and the likes to providers.

Let's add a `points` property to our `PointsProvider`, which will be a map of
a `Player` and their points:

=== "Luau"

    ```Lua hl_lines="6"
    local prvd = -- Import Prvd 'M Wrong however you'd like!
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local PointsProvider = {}
    PointsProvider.name = "PointsProvider"
    PointsProvider.points = {}

    return prvd(PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="4"
    import { Provider } from "@rbxts/prvdmwrong"

    @Provider()
    export class Provider {
      public readonly points = new Map<Player, number>()
    }
    ```

To instantiate our `points`, let's also implement a `setDefaultPoints` method
for convenience:

=== "Luau"

    ```Lua hl_lines="8-16"
    local prvd = -- Import Prvd 'M Wrong however you'd like!
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local PointsProvider = {}
    PointsProvider.name = "PointsProvider"
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
    import { Provider } from "@rbxts/prvdmwrong"

    @Provider()
    export class Provider {
      public readonly points = new Map<Player, number>()

      setDefaultPoints(player: Player) {
        this.points.set(player, 10)
      }
    }
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
  -- Now, self.points is helpfully typed as `{ [Player]: number }`!
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
function PointsProvider.setDefaultPoints(self: Self, player: Player)
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

Prvd 'M Wrong provides two lifecycles out of the box. `onInit` runs
sequentially before any other lifecycle methods, methods are expected to be
infallible and preferably non-yielding.

In contrast, `onStart` runs concurrently *after* all other lifecycle
methods have been registered. This means failures and yields do not affect
other providers.

Let's implement the `onStart` lifecycle, where we will set default points for
every player that joins:

=== "Luau"

    ```Lua hl_lines="3 17-24"
    local prvd = -- Import Prvd 'M Wrong however you'd like!
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")

    local PointsProvider = {}
    type Self = typeof(PointsProvider)
    PointsProvider.name = "PointsProvider"
    PointsProvider.points = {}

    function PointsProvider.setDefaultPoints(self: Self, player: Player)
      if self.points[player] ~= nil then
        return
      end
      self.points[player] = 10
    end

    function PointsProvider.onStart(self: Self)
      Players.PlayerAdded:Connect(function(newPlayer)
        self:setDefaultPoints(newPlayer)
      end)
      for _, existingPlayer in pairs(Players:GetPlayers()) do
        self:setDefaultPoints(existingPlayer)
      end
    end

    return prvd(PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="1 2 12-19"
    import { Provider, type OnStart } from "@rbxts/prvdmwrong"
    import { Players } from "@rbxts/services"

    @Provider()
    export class Provider implements OnStart {
      public readonly points = new Map<Player, number>()

      setDefaultPoints(player: Player) {
        this.points.set(player, 10)
      }

      onStart() {
        Players.PlayerAdded.Connect((newPlayer) => {
          this.setDefaultPoints(newPlayer)
        })
        for (const existingPlayer in Players.GetPlayers()) {
          this.setDefaultPoints(existingPlayer)
        }
      }
    }
    ```

---

## Memory

Now we have a problem: [theres a memory
leak.](https://en.wikipedia.org/wiki/Memory_leak)

When we set points for a player, we add the player to the table. What happens
when the player leaves? Nothing. Which is an issue.

That player's data is forever held onto within the `points` table. We need to
clear out that data when the player leaves. Let's hook up our `onStart`
lifecycle with the `Players.PlayerRemoving` event and remove a players points:

=== "Luau"

    ```Lua hl_lines="24-26"
    local prvd = -- Import Prvd 'M Wrong however you'd like!
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")

    local PointsProvider = {}
    type Self = typeof(PointsProvider)
    PointsProvider.name = "PointsProvider"
    PointsProvider.points = {}

    function PointsProvider.setDefaultPoints(self: Self, player: Player)
      if self.points[player] ~= nil then
        return
      end
      self.points[player] = 10
    end

    function PointsProvider.onStart(self: Self)
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

    return prvd(PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="19-21"
    import { Provider, type OnStart } from "@rbxts/prvdmwrong"
    import { Players } from "@rbxts/services"

    @Provider()
    export class Provider implements OnStart {
      readonly points = new Map<Player, number>()

      setDefaultPoints(player: Player) {
        this.points.set(player, 10)
      }

      onStart() {
        Players.PlayerAdded.Connect((newPlayer) => {
          this.setDefaultPoints(newPlayer)
        })
        for (const existingPlayer in Players.GetPlayers()) {
          this.setDefaultPoints(existingPlayer)
        }
        Players.PlayerRemoving.Connect((newPlayer) => {
          this.points.delete(newPlayer)
        })
      }
    }
    ```

---

## Dependencies

Often, providers may depend on other providers, such as a `CombatProvider`
requiring the player's `CharacterProvider`. Prvd 'M Wrong lets you use providers
through dependency resolution.

First, create a file for a new `MathProvider` with the following:

=== "Luau"

    ```Lua
    local prvd = -- Import Prvd 'M Wrong however you'd like!
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    local MathProvider = {}

    function MathProvider:add(a: number, b: number): number
      -- this method is very expensive! takes a lot of time!
      task.wait(5)
      return a + b
    end

    return prvd(MathProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/prvdmwrong"

    @Provider()
    export class MathProvider {
      add(a: number, b: number) {
        // this method is very expensive! takes a lot of time!
        task.wait(5)
        return a + b
      }
    }
    ```

Then, from `PointsProvider`, import your newly created `MathProvider`:

=== "Lua"

    ```Lua
    -- Tweak this based on where you placed the MathProvider
    local MathProvider = require(script.Parent.MathProvider)
    ```

=== "TypeScript"

    ```TypeScript
    // Tweak this based on where you placed the MathProvider
    import { MathProvider } from "./math-provider"
    ```

Finally, just specify your provider uses another provider:

=== "Luau"

    ```Lua hl_lines="6 12 33-37"
    local prvd = -- Import Prvd 'M Wrong however you'd like!
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")

    -- Tweak this based on where you placed the MathProvider
    local MathProvider = require(script.Parent.MathProvider)

    local PointsProvider = {}
    type Self = typeof(PointsProvider)
    PointsProvider.name = "PointsProvider"
    PointsProvider.points = {}
    PointsProvider.mathProvider = MathProvider

    function PointsProvider.setDefaultPoints(self: Self, player: Player)
      if self.points[player] ~= nil then
        return
      end
      self.points[player] = 10
    end

    function PointsProvider.onStart(self: Self)
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

    function PointsProvider.addPoints(self: Self, player: Player, amount: number)
      local currentPoints = self.points[player]
      local newPoints = self.mathProvider.add(currentPoints, amount)
      self.points[player] = newPoints
    end

    return prvd(PointsProvider)
    ```

=== "TypeScript"

    ```TypeScript hl_lines="5 10 28-32"
    import { Provider, type OnStart } from "@rbxts/prvdmwrong"
    import { Players } from "@rbxts/services"

    // Tweak this based on where you placed the MathProvider
    import { MathProvider } from "./math-provider"

    @Provider()
    export class Provider implements OnStart {
      readonly points = new Map<Player, number>()
      mathProvider = MathProvider

      setDefaultPoints(player: Player) {
        this.points.set(player, 10)
      }

      onStart() {
        Players.PlayerAdded.Connect((newPlayer) => {
          this.setDefaultPoints(newPlayer)
        })
        for (const existingPlayer in Players.GetPlayers()) {
          this.setDefaultPoints(existingPlayer)
        }
        Players.PlayerRemoving.Connect((newPlayer) => {
          this.points.delete(newPlayer)
        })
      }

      add(player: Player, amount: number) {
        const currentPoints = this.points.get(player)
        const newPoints = this.mathProvider.add(currentPoints, amount)
        this.points.set(player, newPoints)
      }
    }
    ```

!!! danger "Do not use dependencies outside of lifecycle methods!"

    Prvd 'M Wrong only returns a shadow of the `use()`-d provider. **You cannot
    use it outside of lifecycle methods.**

    Behind the scenes, Prvd 'M Wrong will keep track of what dependencies your
    provider uses, figure out the correct load order for you, and inject your
    dependencies.

    This is also why you can't freeze your provider tables - this prevents Prvd
    'M Wrong from modifying them.

---

## Congratulations

You just successfully wrote your first provider using Prvd 'M Wrong!

That was a taste of Prvd 'M Wrong. Later on, you will learn how to register your
own lifecycle methods, use Prvd 'M Wrong networking primitives, and creating your
own components.

You can find the completed modules for MathProvider and PointsProvider in [the
`examples` directory.](https://github.com/prvdmwrong/prvdmwrong/tree/main/examples)

Once you're comfortable writing providers, you are ready to take on the rest of
what Prvd 'M Wrong offers.
