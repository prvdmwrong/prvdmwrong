# Startup

With your providers defined, its time to start Prvd 'M Wrong.

## Preloading

It's necessary to preload your providers to for Prvd 'M Wrong to pick it up. For
convenience, you can use the `prvd.preload(instances, predicate)` function,
which will load all modules given an array of instances:

<section class="only-luau" markdown>

```Luau
local prvd = -- Import Prvd 'M Wrong however you wish!

prvd.preload(script.Providers:GetChildren())
```

</section><section class="only-rbxts" markdown>

```TypeScript
import prvd from "@prvdmwrong/core"

prvd.preload(script.Providers.GetChildren())
```

</section>

You can also pass a predicate function to filter the target modules:

<section class="only-luau" markdown>

```Luau
prvd.preload(
  script.Providers:GetChildren(),
  function(module: ModuleScript)
    return module.Name:find("Provider$") ~= nil
  end
)
```

</section><section class="only-rbxts" markdown>

```TypeScript
prvd.preload(script.Providers.GetChildren(), (module) => {
  return module.Name.find("Provider$") !== undefined
})
```

</section>

## Startup

Finally, start Prvd 'M Wrong, and you're off to the races:

<section class="only-luau" markdown>

```Luau
prvd.start()
```

</section><section class="only-rbxts" markdown>

```TypeScript
prvd.start()
```

</section>

If another script requires Prvd 'M Wrong to be ignited, `awaitStart()` can be
used, which will yield until Prvd 'M Wrong has finished starting up:

<section class="only-luau" markdown>

```Luau
prvd.awaitStart()
```

</section><section class="only-rbxts" markdown>

```TypeScript
prvd.awaitStart()
```

</section>

Alternatively, if you need to bind to startup, `onStart(callback)` can be used,
which will spawn the callback when Prvd 'M Wrong has fully ignited:

<section class="only-luau" markdown>

```Luau
prvd.onStart(function()
  print("started!")
end)
```

</section><section class="only-rbxts" markdown>

```TypeScript
prvd.onStart(() => {
  print("started!")
})
```

</section>
