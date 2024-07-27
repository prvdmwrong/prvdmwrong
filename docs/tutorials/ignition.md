# Ignition

With your providers defined, its time to ignite Oh My Prvd.

## Preloading

It's necessary to preload your providers to for Oh My Prvd to pick it up. For
convenience, you can use the `preloadProviders()` function, which will load all
providers recursively:

=== "Luau"

    ```lua
    local prvd = require("@pkg/ohmyprvd")
    prvd.preloadProviders(script.Providers)
    ```

=== "TypeScript"

    ```ts
    import { preloadProviders } from "@rbxts/ohmyprvd"
    preloadProviders(script.Providers)
    ```

You can also specify both a predicate function and what instances to preload:
`LoadMode.Children` for just the children, or `LoadMode.Descendants` for all
descendants:

=== "Luau"

    ```lua hl_lines="4-7"
    local prvd = require("@pkg/ohmyprvd")
    prvd.preloadProviders(
      script.Providers,
      function(module: ModuleScript)
        return module.Name:find("Provider^") ~= nil
      end,
      prvd.LoadMode.Children
    )
    ```

=== "TypeScript"

    ```ts hl_lines="4-5"
    import { LoadMode, preloadProviders } from "@rbxts/ohmyprvd"
    preloadProviders(
      script.Providers,
      (module) => module.Name.find("Provider^") !== undefined,
      LoadMode.Children
    )
    ```

## Ignite

Finally, ignite Oh My Prvd, and you're off to the races:

```TypeScript
prvd.ignite()
```

If another script requires Oh My Prvd to be ignited, `awaitIgnition()` can be
used, which will yield until Oh My Prvd is fully ignited:

```TypeScript
prvd.awaitIgnition()
```

Alternatively, if you need to bind to ignition, `onIgnition(callback)` can be
used, which will spawn the callback when Oh My Prvd has fully ignited:

=== "Luau"

    ```Lua
    prvd.onIgnition(function()
      print("ignited!")
    end)
    ```

=== "TypeScript"

    ```TypeScript
    prvd.onIgnition(() => print("ignited!"))
    ```
