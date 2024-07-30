<div class="ompdoc-api-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-api-tags">
<span>function</span>
<span>since v0.1</span>
</div>

# ignite

Ignites Oh My Prvd. Expected to be called once in an environment, e.g. once on
the server and once on the client.

All necessary providers should be preloaded before calling this as newly created
providers will not run its lifecycle events.

=== "Luau"

    ```Lua
    function prvd.ignite(
      options: {
        logLevel: "none" | "verbose" | nil,
        profiling: boolean?,
      }?
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const ignite: (
      options: Partial<Options> = {
        logLevel: "none",
        profiling: RunService.IsStudio(),
      }
    ) => void
    ```

---

## Parameters

### options `#!lua : Partial<Options>`

Configures how Oh My Prvd will ignite. The following are the available
configuration options:

- `#!lua logLevel: "none" | "verbose"` configures if Oh My Prvd should log trace
  information to the console, defaults to none.
- `#!lua profiling: boolean` configures if built-in lifecycle events should be
  profiled with `debug.setmemorycategory` and `debug.profilebegin`, defaults to
  whether the current session is running in Roblox Studio.

---

## Learn More

- [Ignition tutorial](../../../learn/ignition.md)
