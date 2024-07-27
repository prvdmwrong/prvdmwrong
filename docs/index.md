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
Oh My Prvd is a delightful framework for next-generation Roblox game
development.
</p>

<p>
Oh My Prvd accelerates the process with providers, connecting the top-level
design of your game. Choose to mix in networking and components as you need.
Enjoy a development experience that fades into the background, freeing you to
build faster and shout:
</p>

<b style="font-size: 1.5em;" markdown>"Oh, My Prvd!"</b>

<nav markdown>

<a href="./tutorials/">Get Started</a> ·
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

---

Create providers to handle the top level logic of your game:

=== "Luau"

    ```Lua
    local CoinsProvider = {}
    return prvd.Provider("CoinsProvider", CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    export const CoinsProvider = prvd.Provider("CoinsProvider", {
    })
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

    return prvd.Provider("CoinsProvider", CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    export const CoinsProvider = Provider("CoinsProvider", {
      balance: Map<Player, number> = {},

      addCoins(
        player: Player,
        coins: number
      ) {
        this.coins[person] += coins
      }
    })

    export = CoinsProvider
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

    return prvd.Provider("RewardsProvider", RewardsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    export const RewardsProvider = Provider("RewardsProvider", {
      coinsProvider = use(CoinsProvider)

      addCoins(
        person: Player
      ) {
        this.coinsProvider:addCoins(player, coins)
      }
    })

    export = RewardsProvider
    ```

Finally, preload your providers, then ignite Oh My Prvd, and you're off to the races:

```TypeScript
prvd.loadDescendants(ServerScriptService.Providers)
prvd.ignite()
```

---

## :material-numeric-2-circle-outline: Networking

---

## :material-numeric-3-circle-outline: Modding

</section>
