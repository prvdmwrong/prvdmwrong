<div class="ompdoc-reference-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-reference-tags">
<span class="ompdoc-reference-highlight">type</span>
<span class="ompdoc-reference-since">since v0.1</span>
</div>

# :octicons-checklist-16: Options

Configures how Oh My Prvd will ignite. The following are the available
configuration options: This type is not useful outside of Oh My Prvd itself;
prefer to specify startup options as a parameter of [`
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

- [startup tutorial](../../../tutorials/fundamentals/startup.md)
