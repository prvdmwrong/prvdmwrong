---
  template: home.html
  hide:
    - navigation
    - toc
---

<section class="pmwdoc-home-hero" markdown>

<section class="pmwdoc-home-hero-inner" markdown>

<!-- <h1 style="font-size: 0; margin: 0; padding: 0; opacity: 0;">Prvd 'M Wrong</h1> -->
<!-- <img
  src="./assets/wordmark-dark.svg#only-dark"
  alt="Prvd 'M Wrong"
  width="500px"/>
<img
  src="./assets/wordmark-light.svg#only-light"
  alt="Prvd 'M Wrong"
  width="500px"/> -->
<h1>Built on modern standards,<br/>you're simply going to build better games.</h1>

<p>
Roblox games have become increasingly complex, with sprawling mazes of
dependencies, incomplete frameworks, and a challenging development experience.
</p>

<p>
No longer. Prvd 'M Wrong is a framework that leaves you with the fun stuff,
delivering type-safe APIs and dependency resolution, along with comprehensive
documentation, an ecosystem of packages, and unparalleled DX. Zero bloat,
plugins, or lock-in required.
</p>

<nav>

<a href="./tutorials/" class="md-button md-button--primary">Tutorials</a>
<a href="./tutorials/installation/" class="md-button">Installation</a>
<a href="./api-reference/" class="md-button">API Reference</a>

</nav>

</section>

</section>

<section class="pmwdoc-home-body" markdown>

<!-- <ul class="pmwdoc-home-list">
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

<br/> -->

<br/>

<!-- Familiar -->

<section class="grid" markdown>

<section markdown>

<section class="only-luau" markdown>

```Luau
local prvd = require("@pkg/prvdmwrong-core")
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

</section><section class="only-rbxts" markdown>

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

</section>

</section>

<section markdown>

<!-- <span style="font-size: 3em; line-height: 0; margin: 0;" markdown>:octicons-heart-16:</span> -->

<h2>
Familiar
</h2>

<p style="font-size: 1.125em;">
Prvd 'M Wrong stands on the shoulders of giants, particularly Flamework and
Knit, building on a proven service provider architecture.
</p>

Create service providers to handle the top level logic of your game, baked with
natural type-safety and intellisense, built-in dependency resolution,
first-class lifecycles, topped with pragmatic APIs.

Transition your entire codebase with one of the many compatibility packages.
Just change where you require the original framework, and let Prvd 'M Wrong do
the heavy lifting.

Can your `Knit.CreateService` or `@Service()` do better?

</section>

</section>

<br/>

<!-- Batteries Included -->

<div class="prvdmwrong-home-features">

<ul>
<li>Providers</li>
<li>Dependency Resolution</li>
<li>Type Safety</li>
<li>TypeScript</li>
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

# Batteries Included

<p style="font-size: 1.125em;">
Prvd 'M Wrong brings all core features expected by a modern framework and even
improves some of them for you. Mix in packages for networking, components, and
pre-made lifecycles as needed. Absolutely zero bloat, transformers, or
extensions required.
</p>

<br/>

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
<!-- <br/>
<span class="pmwdoc-version" markdown>
Version
<code id="pmwdoc-version">(fetching)</code>
from
[NPM](https://www.npmjs.com/package/@prvdmwrong/core)
[Wally](https://wally.run/package/prvdmwrong/core)
[Pesde](https://pesde.daimond113.com/packages/prvdmwrong/core/0.2.0-dev.12)
</span> -->
<!-- <script src="assets/javascripts/latest-version.js" defer></script> -->
<a href="./tutorials/" class="md-button md-button--primary">Get Started</a>
<a href="https://github.com/prvdmwrong/prvdmwrong/releases" class="md-button">Download</a>
<a href="./api-reference/" class="md-button">API Reference</a>

</section>

</section>
