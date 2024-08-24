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
Prvd 'M Wrong is a service provider framework for a next-generation Roblox.
</p>

<p>
Once installed, your game will become your money back. Prvd 'M Wrong accelerates
the process with providers, connecting the top-level design of your game. Choose
to mix in networking and components as you need. Randoms will approach you and
ask, <i>"are you wealthy or do you make a six-figure salary?"</i>
</p>

<p>
Cherish a development experience that fades into the background, freeing you to
build faster and prove 'm wrong. It's the swaggest Roblox game framework in
town.
</p>

<nav markdown>

<a href="./tutorials/" class="md-button md-button--primary">Get Started</a>
<a href="https://github.com/prvdmwrong/prvdmwrong/releases" class="md-button">Download</a>
<a href="./reference/" class="md-button">API Reference</a>

<span class="pmwdoc-version" markdown>
Version
<code id="pmwdoc-version">(fetching)</code>
from
[NPM](https://www.npmjs.com/package/@prvdmwrong/core)
[Wally](https://wally.run/package/prvdmwrong/core)
[Pesde](https://pesde.daimond113.com/packages/prvdmwrong/core/0.2.0-dev.12)
</span>
<script src="assets/javascripts/latest-version.js" defer></script>

</nav>

</section>

</section>

<section class="pmwdoc-home-body" markdown>

<ul class="pmwdoc-home-list">
<li>
<b>5kb</b>
<p>Minified + Gzipped</p>
</li>
<li>
<b>Luau & TypeScript</b>
<p>Support</p>
</li>
<li>
<b>Open Source</b>
<p>Forever</p>
</li>
</ul>

<br/>

<!-- Familiar -->

<section class="grid" markdown>

=== "Luau"

    ```Lua
    local prvd = require("@pkg/prvdmwrong")
    local CharacterProvider = require("./character-provider")

    -- ... snip ...

    local CombatProvider = {}
    type Self = typeof(CombatController)

    -- Just specify providers to use them!
    CombatProvider.characterProvider = CharacterProvider

    -- `onStart` is a built-in startup lifecycle.
    function CombatProvider:onStart()
      print("Hello, Prvd 'M Wrong!")
    end

    -- Providers can have *anything*!
    function CombatProvider.performMove(self: Self, move: CombatMove)
      local character = self.characterProvider:awaitCharacter()
      character:PivotTo(character.Position * move.startPosition)
    end

    return prvd(CombatProvider)
    ```

=== "TypeScript"

    ```TypeScript
    import { Provider, OnStart } from "@prvdmwrong/core"
    import { CharacterProvider } from "./character-provider"

    // ... snip ...

    @Provider()
    export class CombatProvider implements OnStart {
      // Just specify providers to use them!
      public characterProvider = CharacterProvider

      // `onStart` is a built-in startup lifecycle.
      public onStart() {
        print("Hello, Prvd 'M Wrong!")
      }

      // Providers can have *anything*!
      public performMove(move: CombatMove) {
        const character = this.characterProvider.awaitCharacter()
        character.PivotTo(character.Position.mul(move.startPosition))
      }
    }
    ```

<section markdown>

<span style="font-size: 3em; line-height: 0; margin: 0;" markdown>:octicons-heart-16:</span>

# Familiar

<p style="font-size: 1.25em;">
Prvd 'M Wrong stands on the shoulders of giants, particularly Flamework and
Knit. Built on a proven service provider architecture, cherish a development
experience that fades into the background.
</p>

Create service providers to handle the top level logic of your game, baked with
natural type-safety and intellisense, built-in dependency injection/inversion,
first-class lifecycles, and pragmatic APIs.

Readable? Powerful? Can your `Knit.CreateService` or `@Flamework.Service()` do
better?

</section>

</section>

<br/>

---

<br/>

<!-- Batteries Included -->

<div class="prvdmwrong-home-features">

<ul>
<li>Providers</li>
<li>Dependencies</li>
<li>Type-Safe APIs</li>
<li>TypeScript Declarations</li>
</ul>

<ul style="animation-direction: reverse;">
<li>Modding</li>
<li>Referencing</li>
<li>Lifecycles</li>
<li>Reflection Metadata</li>
</ul>

<ul>
<li>Networking</li>
<li>Components</li>
<li>Debugger</li>
<li>Compatibility Layers</li>
</ul>

</div>

<span style="font-size: 3em; line-height: 0; margin: 0;" markdown>:octicons-zap-16:</span>

# Batteries Included

<p style="font-size: 1.25em;">
Prvd 'M Wrong brings all core features expected by a framework and even improves some
of them for you. Absolutely zero bloat, transformers, or extensions required.
</p>

Need more? Mix in packages for networking, components, and pre-made lifecycles
as needed. Tired of frameworks like Knit or Lumin? Prvd 'M Wrong is the
difference between a coal mine with dead canary birds littered around and a
meadow of wildflowers and dancing gazelles, with a cool breeze and singing birds
all around. It's refreshing.

<br/>

---

<br/>

<!-- Footer -->

<section style="text-align: center;" markdown>

<img
  src="./assets/wordmark-dark.svg#only-dark"
  alt="Prvd 'M Wrong"
  width="500px"/>
<img
  src="./assets/wordmark-light.svg#only-light"
  alt="Prvd 'M Wrong"
  width="500px"/>
<br/>
<a href="./tutorials/" class="md-button md-button--primary">Get Started</a>
<a href="https://github.com/prvdmwrong/prvdmwrong/releases" class="md-button">Download</a>
<a href="./reference/" class="md-button">API Reference</a>

</section>

</section>
