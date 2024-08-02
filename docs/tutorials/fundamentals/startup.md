# Startup

With your providers defined, its time to start Oh My Prvd.

## Preloading

It's necessary to preload your providers to for Oh My Prvd to pick it up. For
convenience, you can use the `prvd.preload(instances, predicate)` function,
which will load all modules given an array of instances:

=== "Luau"

    ```lua
    local prvd = require("@pkg/ohmyprvd")
    prvd.preload(script.Providers:GetChildren())
    ```

=== "TypeScript"

    ```ts
    import { preload } from "@rbxts/ohmyprvd"
    preload(script.Providers.GetChildren())
    ```

You can also pass a predicate function to filter the target modules:

=== "Luau"

    ```lua hl_lines="4-6"
    local prvd = require("@pkg/ohmyprvd")
    prvd.preload(
      script.Providers.GetChildren(),
      function(module: ModuleScript)
        return module.Name:find("Provider$") ~= nil
      end
    )
    ```

=== "TypeScript"

    ```ts hl_lines="4"
    import { preload } from "@rbxts/ohmyprvd"
    preload(
      script.Providers.GetChildren(),
      (module) => module.Name.find("Provider$") !== undefined
    )
    ```

## Startup

Finally, start Oh My Prvd, and you're off to the races:

```TypeScript
prvd.start()
```

If another script requires Oh My Prvd to be ignited, `awaitStart()` can be used,
which will yield until Oh My Prvd is fully ignited:

```TypeScript
prvd.awaitStart()
```

Alternatively, if you need to bind to startup, `onStart(callback)` can be used,
which will spawn the callback when Oh My Prvd has fully ignited:

=== "Luau"

    ```Lua
    prvd.onStart(function()
      print("ignited!")
    end)
    ```

=== "TypeScript"

    ```TypeScript
    onStart(() => {
      print("ignited!")
    })
    ```
