# Oh My Prvd

<img src="assets/logo.svg" width="300px" align="right" alt="Logo"/>

![CI](https://github.com/team-fireworks/ohmyprvd/actions/workflows/ci.yml/badge.svg)

Oh My Prvd is a delightful framework for next-generation Roblox game
development.

Boring. Do it again.

***Oh My Prvd will not make you a front page developer, but you may feel like
one.***

It accelerates the process with providers, connecting the top-level design of
your game. Choose to mix in networking and components as you need. Oh My Prvd
provides a seamless, next-generation development experience that fades into the
background, freeing you to build faster and shout: **Oh, My Prvd!**

## Highlights

- Type-safe APIs for both Luau and TypeScript
- Featherlight, choose to mix in packages as you need
- Uses dependency injection for cleaner code organization
- Extendable through the modding API
- Non-intrusive lifecycle events for flexibility
- Designed for clarity with syntax inspired by Rust

> **Warning:** Oh My Prvd is in early development. Portions of the API may
> break, be changed, or outright deleted. There will be dragons.

Install Oh My Prvd with your preferred package manager:

```sh
# Wally
wally add @znotfireman/ohmyprvd
# npm
npm i @znotfireman/ohmyprvd
# pnpm
pnpm i @znotfireman/ohmyprvd
```

## Getting Started

Oh My Prvd allows you to define providers for your game logic. These *provide*
specific functions within your game, e.g. you might create a `SaveDataProvider`
to manage save files or a `CameraProvider` to handle player camera movement.

### Boilerplate

This is the minimum structure of a provider, which can be used and hook onto
lifecycle events:

```lua
local prvd = require("@pkg/ohmyprvd")

local LeProvider = {}
return prvd.create("LeProvider", LeProvider)
```

```ts
import { create } from "@rbxts/ohmyprvd"

export const LeProvider = create("LeProvider", {})
```

### Dependencies

Often, providers may depend on other providers, such as a `CombatProvider`
requiring the player's `CharacterProvider`. Catalyst lets you use providers
through dependency injection.

Just specify your provider `use()`s another provider:

```lua
local prvd = require("@pkg/ohmyprvd")
local CharacterProvider = require("./character-provider")

local CombatProvider = {
  characterProvider = prvd.use(CharacterProvider)
}

function CombatController.performMove(
  self: typeof(CombatController),
  move: CombatMove
)
  local character = self.characterProvider:awaitCharacter()
  -- do something with the character
end

return prvd.create("CombatProvider", CombatProvider)
```

```ts
import { create, use } from "@rbxts/ohmyprvd"
import { CharacterProvider } from "./character-controller"

export const CombatProvider = create("CombatProvider", {
  characterProvider: use(CharacterProvider)

  performMove(move: CombatMove) {
    const character = this.characterProvider.awaitCharacter()
    // do something with the character
  }
})
```

### Ignition

With your providers defined, its time to ignite Oh My Prvd.

It's necessary to preload your providers to for Oh My Prvd to pick it up. For
convenience, you can use the `addProviders()` function, which will load all
providers recursively:

```lua
local prvd = require("@pkg/ohmyprvd")
prvd.addProviders(script.Providers)
```

```ts
import { addProviders } from "@rbxts/ohmyprvd"
addProviders(script.Providers)
```

Finally, ignite Oh My Prvd, and you're off to the races:

```ts
prvd.ignite()
```

## FAQ

### How do you say Oh My Prvd?

However you want:

- *Oh, my prvd!* for excitement
- *Oh, my providers!* for completeness
- *O-m-p!* for brevity
- *Ommp!* for power
