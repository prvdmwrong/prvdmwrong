---
hide:
  - navigation
  - toc
---

<section class="pmwdoc-home-hero" markdown>

<section class="pmwdoc-home-hero-inner" markdown>

<h1 style="display: none;">Prvd 'M Wrong</h1>
<img
  src="./assets/wordmark-dark.svg#only-dark"
  alt="Prvd 'M Wrong"
  width="500px"/>
<img
  src="./assets/wordmark-light.svg#only-light"
  alt="Prvd 'M Wrong"
  width="500px"/>

<p>
Prvd 'M Wrong is a game framework for a next-generation Roblox.
</p>

<p>
Once installed, your game will become your money back. Prvd 'M Wrong accelerates
the process with providers, connecting the top-level design of your game. Choose
to mix in networking and components as you need.
</p>

<p>
Cherish a development experience that fades into the background, freeing you to
build faster and prove 'm wrong. It's the swaggest framework in town!
</p>

<nav markdown>

<a href="./tutorials/">Tutorials</a> ·
<a href="https://github.com/team-fireworks/prvdmwrong/releases">Download</a> ·
:octicons-zap-24: Batteries included

</nav>

</section>

</section>

<section class="pmwdoc-home-content" markdown>

=== "Luau"

    ```Lua
    local prvd = require("@pkg/prvdmwrong")
    local CharacterProvider = require("./character-provider")

    local CombatProvider = {}
    CombatProvider.characterProvider = prvd.use(CharacterProvider)

    function CombatProvider:onStart()
      print("Hello, Prvd 'M Wrong!")
    end

    function CombatProvider.performMove(self: typeof(CombatController), move: CombatMove)
      local character = self.characterProvider:awaitCharacter()
      -- do something with the character
    end

    return prvd(CombatProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider, use, type OnStart } from "@rbxts/prvdmwrong"
    import { CharacterProvider } from "./character-provider"

    @Provider()
    export class CombatProvider implements OnStart {
      public characterProvider: use(CharacterProvider)

      public onStart() {
        print("Hello, Prvd 'M Wrong!")
      }

      public performMove(move: CombatMove) {
        const character = this.characterProvider.awaitCharacter()
        // do something with the character
      }
    }
    ```

</section>

<aside class="pmwdoc-home-aside">

Scroll down for a quick look at the three main highlights

</aside>

<section class="pmwdoc-home-body" markdown>

## ① Providers

Prvd 'M Wrong introduces providers for your game logic. These *provide* specific
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
    type Self = typeof(CoinsProvider)
    CoinsProvider.balance = {}

    function CoinsProvider.addCoins(self: Self, player: Player, coins: number)
      self.coins[person] += coins
    end

    return prvd.new("CoinsProvider", CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    @Provider({})
    export class CoinsProvider {
      balance: Map<Player, number> = {},

      addCoins(player: Player, coins: number) {
        this.coins[person] += coins
      }
    })
    ```

Providers can `use()` other providers. Prvd 'M Wrong will provide its types and
figure out a corresponding load order for you:

=== "Luau"

    ```Lua
    local RewardsProvider = {}
    type Self = typeof(CoinsProvider)
    RewardsProvider.coinsProvider = prvd.use(CoinsProvider)

    function RewardsProvider.addWinRewards(self: Self, player: Player)
      self.coinsProvider:addCoins(player, 30)
    end

    return prvd.new("RewardsProvider", RewardsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    @Provider({})
    export class RewardsProvider {
      coinsProvider = use(CoinsProvider)

      addCoins(person: Player) {
        this.coinsProvider:addCoins(player, coins)
      }
    }
    ```

Finally, preload your providers, then start Prvd 'M Wrong, and you're off to the races:

=== "Luau"

    ```Lua
    prvd.preload(ServerScriptService.Providers:GetDescendants())
    prvd.start(options)
    ```

=== "TypeScript"

    ```TypeScript
    preload(ServerScriptService.Providers.GetDescendants())
    start(options)
    ```

---

## ② Mixins

---

## ③ Extensible

Prvd 'M Wrong brings comprehensive APIs for extending the framework. Here's one of
the common ones, `Lifecycle` to implement your own lifecycle methods:

=== "Luau"

    ```Lua
    -- this interface satisfies our method
    type OnCharacterAdded = {
      onCharacterAdded(self: unknown, character: Model) -> ()
    }

    -- `fireConcurrent` is a built-in lifecycle handler that spawns listeners
    local characterAdded = Lifecycle("onCharacterAdded", fireConcurrent)

    -- now fire the lifecycle method!
    if (LocalPlayer.Character) then
      characterAdded:fire(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(function(character)
      characterAdded:fire(character)
    end)
    ```

=== "TypeScript"

    ```TypeScript
    // this interface satisfies our method
    interface OnCharacterAdded {
      onCharacterAdded(character: Model): void
    }

    // `fireConcurrent` is a built-in lifecycle handler that spawns listeners
    const characterAdded = Lifecycle("onCharacterAdded", fireConcurrent)

    // now fire the lifecycle method!
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
    local prvd = require(ReplicatedStorage.Packages.prvdmwrong)

    local CombatProvider = {}
    function CombatProvider:onCharacterAdded(character: Model)
      local rootPart: BasePart = assert(character:FindFirstChild("HumanoidRootPart"))
      -- do something with rootPart
    end

    return prvd.new(CombatProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider } from "@rbxts/prvdmwrong"

    @Provider({})
    export class CombatProvider implements OnCharacterAdded {
      onCharacterAdded(character) {
        const rootPart: BasePart = assert(character:FindFirstChild("HumanoidRootPart"))
        // do something with rootPart
      }
    }
    ```

</section>
