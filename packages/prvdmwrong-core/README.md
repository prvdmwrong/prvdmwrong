<div align="center">
<img
  align="center"
  src="https://raw.githubusercontent.com/prvdmwrong/prvdmwrong/main/assets/wordmark-dark.svg#gh-dark-mode-only"
  alt="Prvd 'M Wrong"
  width="500px"/>
<img
  align="center"
  src="https://raw.githubusercontent.com/prvdmwrong/prvdmwrong/main/assets/wordmark-light.svg#gh-light-mode-only"
  alt="Prvd 'M Wrong"
  width="500px"/>

<br/>
<br/>

[![Continuous Integration](https://img.shields.io/github/actions/workflow/status/prvdmwrong/prvdmwrong/ci.yml?style=flat-square&label=Continuous%20Integration)](https://github.com/prvdmwrong/prvdmwrong/actions/workflows/ci.yml)
[![Documentation Status](https://img.shields.io/github/actions/workflow/status/prvdmwrong/prvdmwrong/docs.yml?style=flat-square&label=Documentation)](https://github.com/prvdmwrong/prvdmwrong/actions/workflows/docs.yml)<br/>
![Prvd 'M Wrong is dual-licensed under MIT](https://img.shields.io/badge/license-MIT%20or%20Apache%202.0-blue?style=flat-square)
[![Releases](https://img.shields.io/github/v/tag/prvdmwrong/prvdmwrong?&style=flat-square)](https://github.com/prvdmwrong/prvdmwrong/releases)
[![NPM Version](https://img.shields.io/npm/v/%40prvdmwrong%2Fcore?style=flat-square)](https://www.npmjs.com/package/@prvdmwrong/core)
</br>
<a href="https://github.com/prvdmwrong/prvdmwrong/releases">Download</a> ·
<a href="https://prvdmwrong.github.io/prvdmwrong/latest">Documentation</a> ·
<a href="https://prvdmwrong.github.io/prvdmwrong/latest/reference">Reference</a> ·
<a href="CHANGELOG.md">Changelog</a>
</div>

Prvd 'M Wrong is a service provider framework for a next-generation Roblox.

Sounds boring. Let's try again.

**Prvd 'M Wrong will not make you a front page Roblox developer... but you may
feel like one.**

Once installed, your game will become your money back. Prvd 'M Wrong accelerates
the process with providers, connecting the top-level design of your game. Choose
to mix in networking and components as you need. Randoms will approach you and
ask, *"are you wealthy or do you make a six-figure salary?"*

Cherish a development experience that fades into the background, freeing you to
build faster and **prvd 'm wrong.** It's the swaggest framework in town!

Sparked your interest? [Get going in minutes with our on-rails
tutorial.](https://prvdmwrong.github.io/prvdmwrong/latest/tutorials/)

## Highlights

- Type-safe APIs for both Luau and TypeScript
- Featherlight, choose to mix in packages as you need
- Uses dependency injection for cleaner code organization
- Made to be extendable through modding APIs
- Non-intrusive first-class lifecycle events for flexibility
- Pragmatic and sensible API that makes development fun

## Code Sample

```Luau
local prvd = require("pkg/prvdmwrong")
local CharacterProvider = require("./character-provider")

local CombatProvider = {}
type Self = typeof(CombatController)
CombatProvider.characterProvider = prvd.use(CharacterProvider)

function CombatProvider:onStart()
  print("Hello, Prvd 'M Wrong!")
end

function CombatProvider.performMove(self: Self, move: CombatMove)
  local character = self.characterProvider:awaitCharacter()
  -- do something with the character
end

return prvd(CombatProvider)
```

```TypeScript
import { Provider, use } from "@prvdmwrong/core"
import { CharacterProvider } from "./character-provider"

@Provider()
export class CombatProvider {
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