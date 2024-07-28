# Options

Configures how Oh My Prvd will ignite. The following are the available
configuration options: This type is not useful outside of Oh My Prvd itself;
prefer to specify ignition options as a parameter of [`#!lua
ignite(options)`](../members/ignite.md)

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
