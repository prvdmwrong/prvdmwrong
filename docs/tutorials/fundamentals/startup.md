# Startup

With your providers defined, its time to start Prvd 'M Wrong.

## Preloading

It's necessary to preload your providers to for Prvd 'M Wrong to pick it up. For
convenience, you can use the `prvd.preload(instances, predicate)` function,
which will load all modules given an array of instances:

=== "Luau"

    ```lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.prvdmwrong)

    prvd.preload(script.Providers:GetChildren())
    ```

=== "TypeScript"

    ```ts
    import { preload } from "@rbxts/prvdmwrong"
    preload(script.Providers.GetChildren())
    ```

You can also pass a predicate function to filter the target modules:

=== "Luau"

    ```lua hl_lines="6-8"
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local prvd = require(ReplicatedStorage.Packages.prvdmwrong)

    prvd.preload(
      script.Providers:GetChildren(),
      function(module: ModuleScript)
        return module.Name:find("Provider$") ~= nil
      end
    )
    ```

=== "TypeScript"

    ```ts hl_lines="4"
    import { preload } from "@rbxts/prvdmwrong"
    preload(
      script.Providers.GetChildren(),
      (module) => module.Name.find("Provider$") !== undefined
    )
    ```

## Startup

Finally, start Prvd 'M Wrong, and you're off to the races:

```TypeScript
prvd.start()
```

If another script requires Prvd 'M Wrong to be ignited, `awaitStart()` can be used,
which will yield until Prvd 'M Wrong is fully ignited:

```TypeScript
prvd.awaitStart()
```

Alternatively, if you need to bind to startup, `onStart(callback)` can be used,
which will spawn the callback when Prvd 'M Wrong has fully ignited:

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
