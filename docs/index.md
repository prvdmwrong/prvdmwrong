---
hide:
  - navigation
  - toc
---

<section class="pmwdoc-home-hero" markdown>

<section class="pmwdoc-home-hero-inner" markdown>

<h1 style="font-size: 0; margin: 0; padding: 0; opacity: 0;">Prvd 'M Wrong</h1>
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
to mix in networking and components as you need. Randoms will approach you and
ask, <i>"are you wealthy or do you make a six-figure salary?"</i>
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
      public characterProvider = use(CharacterProvider)

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
    -- Create Luau providers by calling the package itself.
    local CoinsProvider = {}
    return prvd(CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    // Create TypeScript providers by using the Provider decorator on a class.
    @Provider()
    export class CoinsProvider {}
    ```

Providers are just plain modules. It's easy to implement more methods,
properties, and the likes into a provider:

=== "Luau"

    ```Lua
    local CoinsProvider = {}
    -- Alias our provider's type for complete type-safety
    type Self = typeof(CoinsProvider)
    -- Providers can have properties...
    CoinsProvider.balance = {}

    -- ...and methods...
    function CoinsProvider.addCoins(self: Self, player: Player, coins: number)
      -- ...all properties are accessible through `self`!
      self.coins[person] += coins
    end

    return prvd(CoinsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    @Provider()
    export class CoinsProvider {
      // Providers can have properties...
      balance: Map<Player, number> = {},

      // ...and methods...
      addCoins(player: Player, coins: number) {
        // ...all properties are accessible through `this`!
        this.coins[person] += coins
      }
    })
    ```

Providers can `use()` other providers. Prvd 'M Wrong will provide type-safety,
autocomplete, and figure out a corresponding load order for you:

=== "Luau"

    ```Lua
    -- For example, say this rewards provider requires the coins provider.
    local RewardsProvider = {}
    type Self = typeof(CoinsProvider)
    -- Just specify this provider `use()`-s the coins provider...
    RewardsProvider.coinsProvider = prvd.use(CoinsProvider)

    function RewardsProvider.addWinRewards(self: Self, player: Player)
      -- ...and enjoy complete type-safety!
      self.coinsProvider:addCoins(player, 30)
    end

    return prvd.new(RewardsProvider)
    ```

=== "TypeScript"

    ```TypeScript
    // For example, say this rewards provider requires the coins provider.
    @Provider({})
    export class RewardsProvider {
      // Just specify this provider `use()`-s the coins provider...
      coinsProvider = use(CoinsProvider)

      addCoins(person: Player) {
        // ...and enjoy complete type-safety!
        this.coinsProvider:addCoins(player, coins)
      }
    }
    ```

Finally, preload your providers, then start Prvd 'M Wrong, and you're off to the races:

=== "Luau"

    ```Lua
    -- `preload` loads all ModuleScript instances from an array.
    -- This lets Prvd 'M Wrong register providers.
    prvd.preload(ServerScriptService.Providers:GetDescendants())
    -- Now, Prvd 'M Wrong can be started!
    prvd.start(options)
    ```

=== "TypeScript"

    ```TypeScript
    // `preload` loads all ModuleScript instances from an array.
    // This lets Prvd 'M Wrong register providers.
    preload(ServerScriptService.Providers.GetDescendants())
    // Now, Prvd 'M Wrong can be started!
    start(options)
    ```

---

## ② Mixins

Prvd 'M Wrong is featherlight by design, and provides best-in-class packages to
mix-in whenever needed.

---

## ③ Extensible

Prvd 'M Wrong brings comprehensive APIs for extending the framework.

Here's one of the common ones, `Lifecycle` to implement your own lifecycle
methods:

=== "Luau"

    ```Lua
    -- This interface satisfies our method!
    type OnCharacterAdded = {
      onCharacterAdded(self: unknown, character: Model) -> ()
    }

    -- `fireConcurrent` is a built-in lifecycle handler that spawns listeners.
    local characterAdded = Lifecycle("onCharacterAdded", fireConcurrent)

    -- Now fire the lifecycle method!
    if (LocalPlayer.Character) then
      characterAdded:fire(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(function(character)
      characterAdded:fire(character)
    end)
    ```

=== "TypeScript"

    ```TypeScript
    // This interface satisfies our method!
    interface OnCharacterAdded {
      onCharacterAdded(character: Model): void
    }

    // `fireConcurrent` is a built-in lifecycle handler that spawns listeners.
    const characterAdded = Lifecycle("onCharacterAdded", fireConcurrent)

    // Now fire the lifecycle method!
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
    local CombatProvider = {}

    function CombatProvider:onCharacterAdded(character: Model)
      local rootPart: BasePart = assert(character:FindFirstChild("HumanoidRootPart"))
      -- do something with rootPart
    end

    return prvd(CombatProvider)
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

Scripts can also use Prvd 'M Wrong's assortments of hooks. You often use either
`onStart` or `awaitStart` if another script requires Prvd 'M Wrong to be
started:

=== "Luau"

    ```Lua
    -- Let's track if Prvd 'M Wrong has started.
    local hasStarted = false

    -- This function is spawned when Prvd 'M Wrong starts.
    prvd.onStart(function()
      print("Prvd 'M Wrong has started!")
      hasStarted = true
    end)

    -- This yields until Prvd 'M Wrong starts.
    prvd.awaitStart()
    assert(hasStarted == true)
    ```

=== "TypeScript"

    ```TypeScript
    // Let's track if Prvd 'M Wrong has started.
    let hasStarted = false

    // This function is spawned when Prvd 'M Wrong starts.
    onStart(() => {
      print("Prvd 'M Wrong has started!")
      hasStarted = true
    })

    // This yields until Prvd 'M Wrong starts.
    awaitStart()
    assert(hasStarted === true)
    ```

</section>
