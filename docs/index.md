---
hide:
  - navigation
  - toc
---

<section class="ompdoc-home-hero" markdown>

<section class="ompdoc-home-hero-inner" markdown>

<!-- <img src="./assets/logo.svg" width="150px"/> -->

<h1 style="font-weight: 600;">The Roblox Developer's<br/>Secret Weapon</h1>

<p>
Oh My Prvd is a delightful framework for modern Roblox game development.
</p>

<p>
Oh My Prvd accelerates the process with providers, connecting the top-level
design of your game. Choose to mix in networking and components as you need.
Enjoy a development experience that fades into the background, freeing you to
build faster and shout:
</p>

<b style="font-size: 1.5em;" markdown>"Oh, My Prvd!"</b>

<nav markdown>

<a href="./get-started/">Get Started</a> ·
<a href="https://github.com/team-fireworks/ohmyprvd/releases">Download</a> ·
:octicons-zap-24: Batteries included

</nav>

</section>

</section>

<section class="ompdoc-home-content" markdown>

=== "Luau"

    ```Lua
    local prvd = require("@pkg/ohmyprvd")
    local CalculusProvider = require("./calculus-provider")

    local MathProvider = {}
    MathProvider.calculusProvider = prvd.use(CalculusProvider)

    function MathProvider.add(self: typeof(MathProvider), a: number, b: number)
      return self.calculusProvider.add(a, b)
    end

    return prvd.Provider("MathProvider", MathProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider, use } from "@rbxts/ohmyprvd"
    import CalculusProvider from "./calculus-provider"

    export const MathProvider = Provider("MathProvider", {
      calculusProvider = use(CalculusProvider)

      add(a: number, b: number) {
        return this.CalculusProvider.add(a, b)
      }
    })
    export = MathProvider
    ```

</section>

<aside class="ompdoc-home-aside">

Scroll down for a quick look at the three main highlights

</aside>

<section class="ompdoc-home-body" markdown>

## :material-numeric-1-circle-outline: Providers

Oh My Prvd introduces providers for your game logic. These *provide* specific
functions within your game, e.g. you might create a `SaveDataProvider` to manage
save files or a `CameraProvider` to handle player camera movement.

Create providers to handle the top level logic of your game:

=== "Luau"

    ```Lua
    local CoinsProvider = {}
    return prvd.new("CoinsProvider", CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    @Provider({})
    export class CoinsProvider {}
    ```

At the end of the day, providers are just plain tables. It's easy to implement
more methods, properties, and the likes into a provider:

=== "Luau"

    ```Lua
    local CoinsProvider = {}
    CoinsProvider.balance = {}

    function CoinsProvider.addCoins(
      self: typeof(CoinsProvider),
      player: Player,
      coins: number
    )
      self.coins[person] += coins
    end

    return prvd.new("CoinsProvider", CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    @Provider({})
    export class CoinsProvider {
      balance: Map<Player, number> = {},

      addCoins(
        player: Player,
        coins: number
      ) {
        this.coins[person] += coins
      }
    })
    ```

Providers can `use()` other providers. Oh My Prvd will provide its types and
figure out a corresponding load order for you:

=== "Luau"

    ```Lua
    local RewardsProvider = {}
    RewardsProvider.coinsProvider = prvd.use(CoinsProvider)

    function RewardsProvider.addWinRewards(
      self: typeof(CoinsProvider),
      player: Player,
    )
      self.coinsProvider:addCoins(player, 30)
    end

    return prvd.new("RewardsProvider", RewardsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    @Provider({})
    export class RewardsProvider {
      coinsProvider = use(CoinsProvider)

      addCoins(
        person: Player
      ) {
        this.coinsProvider:addCoins(player, coins)
      }
    }
    ```

Finally, preload your providers, then ignite Oh My Prvd, and you're off to the races:

```TypeScript
prvd.preload(ServerScriptService.Providers:GetDescendants())
prvd.start(options)
```

---

## :material-numeric-2-circle-outline: Mixins

---

## :material-numeric-3-circle-outline: Extensible

Oh My Prvd brings comprehensive APIs for extending the framework. Here's one of
the common ones, `Lifecycle` to implement your own lifecycle methods:

=== "Luau"

    ```Lua
    type OnCharacterAdded = {
      onCharacterAdded: (self: unknown, character: Model) -> ()
    }

    local characterAdded = Lifecycle("onCharacterAdded")

    if (LocalPlayer.Character) then
      characterAdded.fire(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(function(character)
      characterAdded.fire(character)
    end)
    ```

=== "TypeScript"

    ```TypeScript
    interface OnCharacterAdded {
      onCharacterAdded: (self: unknown, character: Model) -> ()
    }

    const characterAdded = Lifecycle("onCharacterAdded")
    if (LocalPlayer.Character) {
      characterAdded.fire(LocalPlayer.Character)
    }
    LocalPlayer.CharacterAdded.Connect((character) => {
      characterAdded.fire(character)
    })
    ```

A provider can then hook onto the lifecycle:

=== "Luau"

    ```Lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.ohmyprvd)

    local CombatProvider = {}
    function CombatProvider:onCharacterAdded(character: Model)
      local rootPart: BasePart = assert(character:FindFirstChild("HumanoidRootPart"))
      -- do something with rootPart
    end

    return prvd.new(CombatProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/ohmyprvd"

    @Provider({})
    export class CombatProvider implements OnCharacterAdded {
      onCharacterAdded(character) {
        const rootPart: BasePart = assert(character:FindFirstChild("HumanoidRootPart"))
        // do something with rootPart
      }
    }
    ```

</section>
