<div align="center">
    <picture>
        <source media="(prefers-color-scheme: dark)" srcset="./gh-assets/wordmark-dark.svg" width="600px">
        <source media="(prefers-color-scheme: light)" srcset="/gh-assets/wordmark-light.svg" width="600px">
        <img alt="Prvd 'M Wrong Logo" src="/gh-assets/wordmark-light.svg" width="600px">
    </picture>
</div>
<hr/>

## 💥 Luau's Unstoppable Force

Luau has often meant navigating sprawling mazes of dependencies, grappling with
incomplete frameworks, and a challenging development experience.

No longer. Prvd 'M Wrong is the Luau provider framework, freeing you from
logistical nightmares so you can focus just on your project's logic.

Use Prvd 'M Wrong to structure your project with providers. Prvd 'M Wrong
delivers type-safe APIs, method lifecycles, and dependency injection. 

Whether you prefer batteries to be included, or want to use your favorite 
packages and patterns, Prvd 'M Wrong adapts to your needs.

Built with fantastic user extensibility, modular composability and runtime 
integration, Prvd 'M Wrong can be dropped in for both new projects and existing 
frameworks. In particular, Prvd 'M Wrong gleams anywhere Luau runs, from Roblox 
to Lune.

All free from logistical nightmares and without sprawling mazes of bloaty 
dependencies.

Want to prove them wrong?
[Get going with the Prvd 'M Wrong on rails tutorial,][Tutorial]
or [read through the library of example projects.][Examples]

[Tutorial]: https://prvdmwrong.luau.page/latest/tutorials
[Examples]: https://prvdmwrong.luau.page/latest/examples

## 🚀 Crash Course

Assuming a Roblox project, create a "Providers" folder in ServerScriptService.

Create a new server Script inside ServerScriptService, this is where we will
bootstrap Prvd 'M Wrong.

First, create and start a root. Roots are starting points for Prvd 'M Wrong:

```luau
-- replace with path to Prvd 'M Wrong!
local prvd = require(...)

local root = prvd.root()
    -- use all descendant module scripts inside our Providers folder
    :useModules(script.Parent:WaitForChild("Providers"):GetDescendants())
    -- start!
    :start()

-- when the server closes, the root should be finished.
game:BindToClose(function()
    root:finish()
end)
```

Now, let's create your first provider! Inside your "Providers" folder, create a 
ModuleScript called "TimeProvider":

```luau
-- replace with path to Prvd 'M Wrong!
local prvd = require(...)

-- Providers are just defined as tables.
local TimeProvider = {}

-- When starting the root, Prvd 'M Wrong will construct each provider one by
-- one.
function TimeProvider.constructor(self: TimeProvider)
    self.time = 0
end

-- `start` will be called after all providers have constructed. `start` also
-- runs in it's own thread!
function TimeProvider.start(self: TimeProvider)
    while true do
        self.time += task.wait()
    end
end

-- Prvd 'M Wrong takes advantage of the Luau type solver, so your providers
-- enjoy type safety!
export type TimeProvider = typeof(TimeProvider)

-- Export the provider.
return prvd(TimeProvider)
```

Prvd 'M Wrong can also resolve your provider's dependencies as so the
dependencies it needs are constructed before the dependent. Create a new
"ServerTimeProvider" ModuleScript:

```luau
-- replace with path to Prvd 'M Wrong!
local prvd = require(...)

local ServerTimeProvider = {}

-- `dependencies` is a special table that Prvd 'M Wrong will read and collect
-- dependencies.
ServerTimeProvider.dependencies = {
    -- `depend` tells Prvd 'M Wrong this is a dependency that it should track.
    -- It also refines the type to the actual constructed provider!
    TimeProvider = prvd.depend(require("./TimeProvider"))
}

-- To use the dependencies, get it as the second argument of the constructor: 
function ServerTimeProvider.constructor(
    self: ServerTimeProvider,
    dependencies: typeof(self.dependencies)
)
    -- Need to hold on dependencies for later? Just set it!
    self.timeProvider = dependencies.TimeProvider
end

-- Now you can access `TimeProvider` in other methods!
function ServerTimeProvider.start(self: ServerTimeProvider)
    while true do
        print(
            "The server has been alive for", 
            math.round(self.timeProvider.time), 
            "seconds!"
        )
    end
end

export type ServerTimeProvider = typeof(ServerTimeProvider)
return prvd(ServerTimeProvider)
```

With that, you've written your first Prvd 'M Wrong project, touching on all of 
the major Prvd 'M Wrong concepts!

[In the tutorials][Tutorial], we'll dig deeper into what exactly all of this code 
is doing. Feel free to review these code snippets as many times as you need.

## 🌏 Cultural Impact

Prvd 'M Wrong has a significant cultural impact following the archival of the 
Knit framework. Many packages inspired by Prvd 'M Wrong, which you can use if
you're unsastified, as listed below:

- [Artwork](https://ratplier.github.io/artwork)
- [Saphhire (archived)](https://github.com/Mark-Marks/sapphire)
- [Quill](https://github.com/featherfall-org/quill)

## 📝 License

Prvd 'M Wrong 0.2 is licensed under the Mozilla Public License 2.0.

Note that historical versions of Prvd 'M Wrong were licensed under the MIT
License and sometimes the Apache License 2.0.
