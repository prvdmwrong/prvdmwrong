<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>type</span>
<span>since v0.1</span>
</div>

# Options

Configures how Oh My Prvd will ignite. The following are the available
configuration options: This type is not useful outside of Oh My Prvd itself;
prefer to specify ignition options as a parameter of [`
ignite(options)`](../providers/use.md).

=== "Luau"

    ```Lua
    export type Options = {
      logLevel: "none" | "verbose",
      profiling: boolean
    }
    ```

=== "TypeScript"

    ```TypeScript
    export type Options = {
      logLevel: "none" | "verbose"
      profiling: boolean
    }
    ```

---

## Members

### logLevel `#!lua : "none" | "verbose"`

Configures if Oh My Prvd should log trace information to the console, defaults
to `#!lua "none"`.

### profiling `#!lua : boolean`

Configures if built-in lifecycle events should be profiled with
`debug.setmemorycategory` and `debug.profilebegin`, defaults to whether the
current session is running in Roblox Studio.

---

## Learn More

- [Ignition tutorial](../../../tutorials/ignition.md)
