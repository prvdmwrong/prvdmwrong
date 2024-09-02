# Providers

!!! warning "Under construction"

    This page is under construction - information may be incomplete or missing.

Roblox games are composed of top level *service providers*, which provide a
specific service for the game.

Prvd 'M Wrong formalizes the concept of providers as singletons objects that
provide some top level logic of a game.

---

## Construction

To create Luau providers, call the `prvd` constructor. For TypeScript providers,
prefer to import and use the `Provider` class decorator:

=== "Luau"

    ```Luau linenums="1"
    local prvd = -- Import Prvd 'M Wrong however you'd like!

    local PlayerProvider = {}

    return prvd(PlayerProvider)
    ```

=== "TypeScript"

    ```TypeScript linenums="1"
    import { Provider } from "@prvdmwrong/core"

    @Provider()
    export class PlayerProvider {}
    ```

For Luau providers, wrap the module return with `prvd`:

```Luau linenums="5"
return prvd(PlayerProvider)
```

Keeping the `prvd` constructor at the bottom allows Luau to infer the full type
of the provider as it gets constructed.

Avoid constructing the provider earlier, as Luau will "seal" the provider,
refusing further changes:

```Luau
-- Don't do this! Luau will "seal" the provider, refusing further changes:
local PlayerProvider = prvd({})

-- TypeError: Cannot add property 'players' to table '{ }' & '{| loadOrder: ... |}'
PlayerProvider.players = {}

return PlayerProvider
```

Likewise, avoid constructing the whole provider inside the `prvd` constructor,
as Luau fails to provide the type for it-`self`:

```Luau
-- Don't do this! Luau can't infer the type for it-self:
return prvd {
  -- Seems good...
  players = {},

  getPlayers = function(self)
    -- self is typed as 'a' here... Not useful!
  end
}
```

Games often track additional player session information, such as when the player
joined or the player's leaderstats. Let's define a `PlayerInfo` type, along with
an `info` field to store each player's session information:

=== "Luau"

    ```Luau linenums="3"
    export type PlayerInfo = {
      joinedAt: number,
      coins: number,
    }

    local PlayerProvider = {}
    PlayerProvider.info = {} :: { [Player]: PlayerInfo }
    ```

=== "TypeScript"

    ```TypeScript linenums="3"
    export interface PlayerInfo {
      joinedAt: number,
      coins: number,
    }

    @Provider()
    export class PlayerProvider {
      readonly info = new Map<Player, PlayerInfo>()
    }
    ```

## Lifecycles

Providers and can implement lifecycles by having a method that matches its
lifecycle method.

Prvd 'M Wrong provides two lifecycle events out of the box:

- `onInit` runs sequentially before any other lifecycle methods, methods are
  expected to be infallible and preferably non-yielding.
- In contrast, `onStart` runs concurrently after all other lifecycle methods
  have been registered. This means failures and yields do not affect other
  providers.

Let's implement the `onInit` lifecycle to instantiate new session
information:

=== "Luau"

    ```Luau linenums="1"
    local Players = game:GetService("Players")
    local prvd = -- Import Prvd 'M Wrong however you'd like!

    export type PlayerInfo = {
      joinedAt: number,
      coins: number,
    }

    local PlayerProvider = {}
    PlayerProvider.info = {} :: { [Player]: PlayerInfo }

    function PlayerProvider.onInit(self: typeof(PlayerProvider))
      local function onPlayerAdded(newPlayer: Player)
        self.info[newPlayer] = {
          joinedAt = os.clock(),
          coins = 0
        }
      end

      Players.PlayerAdded:Connect(onPlayerAdded)
      for _, existingPlayer in Players:GetPlayers() do
        onPlayerAdded(existingPlayer)
      end
    end
    ```

=== "TypeScript"

    ```TypeScript linenums="1"
    import { Players } from "@rbxts/services"
    import { Provider, type OnInit } from "@prvdmwrong/core"

    export interface PlayerInfo {
      joinedAt: number,
      coins: number,
    }

    @Provider()
    export class PlayerProvider implements OnInit {
      readonly info = new Map<Player, PlayerInfo>()

      onInit() {
        const onPlayerAdded = (newPlayer: Player) => {
          this.info.set(newPlayer, {
            joinedAt: os.clock(),
            coins: 0
          })
        }

        Players.PlayerAdded.Connect(onPlayerAdded)
        for (const existingPlayer of Players.GetPlayers()) {
          onPlayerAdded(existingPlayer)
        }
      }
    }
    ```

Notice that `onInit` requires the first argument to be `self`, which is `typeof`
the `PlayerProvider`.

This allows Luau to provide useful type information. Notice how if we omit the
`self` argument and use a colon `:` for our method, we lose typings for `self`:

```Luau linenums="12"
function PlayerProvider:onInit()
  local function onPlayerAdded(newPlayer: Player)
    -- self.info is typed as `a` here... not very useful!
    self.info[newPlayer] = {
      joinedAt = os.clock(),
      coins = 0
    }
  end

  Players.PlayerAdded:Connect(onPlayerAdded)
  for _, existingPlayer in Players:GetPlayers() do
    onPlayerAdded(existingPlayer)
  end
end
```

Contrast as to if we typed `self` as a parameter:

```Luau linenums="12"
function PlayerProvider.onInit(self: typeof(PlayerProvider))
  local function onPlayerAdded(newPlayer: Player)
    -- self.info is helpfully typed as `{| [Player]: PlayerInfo |}`!
    self.info[newPlayer] = {
      joinedAt = os.clock(),
      coins = 0
    }
  end

  Players.PlayerAdded:Connect(onPlayerAdded)
  for _, existingPlayer in Players:GetPlayers() do
    onPlayerAdded(existingPlayer)
  end
end
```

`typeof(PointsProvider)` is not very concise. Let's make a type alias,
appropriately named `Self`:

```Luau linenums="9"
local PlayerProvider = {}
type Self = typeof(PlayerProvider)
PlayerProvider.info = {} :: { [Player]: PlayerInfo }
```

We could then easily type `self` as such:

```Luau linenums="13"
function PlayerProvider.onInit(self: Self)
```

Now, methods can use `self` as a shorthand for the `PlayerProvider`, while other
snippets of code could use our method through one of the following:

```Luau
-- pass self directly as an argument...
PlayerProvider.someFutureMethod(PlayerProvider, player)

-- ...or let Luau pass self for us!
PlayerProvider:someFutureMethod(player)
```

## Why Providers?

### The Limitations

ModuleScripts are arguably singletons, being a flat table with fields, methods,
and properties.

```Luau linenums="1"
local MathModule = {}

function MathModule.add(left: number, right: number)
  return left + right
end

return MathModule
```

However, just modules lacks several quality of life features developers enjoy,
including dependency resolution and lifecycles. Consider this timer module below:

```Luau linenums="1"
local RunService = game:GetService("RunService")
local MathModule = require(script.Parent.MathModule)

local TimerModule = {}
TimerModule.elapsedTime = 0

RunService.PostSimulation:Connect(function(dt)
  MathModule.add(TimerModule.elapsedTime, dt)
end)

return TimerModule
```

How does this timer module assert that the math module has finished initializing
before it's used? Why does the timer module have to connect onto
RunService?
