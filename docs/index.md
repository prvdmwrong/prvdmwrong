---
hide:
  - navigation
  - toc
---

<section class="ompdoc-home-hero">

<div class="ompdoc-home-hero-inner">

<h1 style="font-weight: 400;">The Roblox Developer's</br>Secret Weapon</h1>

<p>
Oh My Prvd is a delightful framework for
next-generation Roblox game development.
</p>

<p>
It accelerates the process with providers, connecting the top-level design of
your game. Choose to mix in networking and components as you need. Oh My Prvd
provides a seamless, development experience that fades into the background,
freeing you to build faster and shout:
</p>

<span style="font-size: 1.5em;" markdown><b>"Oh, My Prvd!"</b></span>

</div>

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

    return prvd.create("MathProvider", MathProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { create, use } from "@rbxts/ohmyprvd"
    import CalculusProvider from "./calculus-provider"

    export const MathProvider = prvd.create("MathProvider", {
      calculusProvider = prvd.use(CalculusProvider)

      add(a: number, b: number) {
        return this.CalculusProvider.add(a, b)
      }
    })
    export = MathProvider
    ```

</section>

<section class="ompdoc-home-body" markdown>

## Providers

Oh My Prvd introduces providers for your game logic. These *provide* specific
functions within your game, e.g. you might create a `SaveDataProvider` to manage
save files or a `CameraProvider` to handle player camera movement.

## Networking

## Modding

</section>

## Highlights

- Type-safe APIs for both Luau and TypeScript
- Featherlight, choose to mix in packages as you need
- Uses dependency injection for cleaner code organization
- Extendable through the modding API
- Non-intrusive lifecycle events for flexibility
- Designed for clarity with syntax inspired by Rust
