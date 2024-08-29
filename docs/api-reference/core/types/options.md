<div class="pmwdoc-reference-breadcrumbs">
<a href="../../">Prvd 'M Wrong</a>
<a href="../">Core</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">type</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-checklist-16: Options

Configures how Prvd 'M Wrong will ignite. The following are the available
configuration options: This type is not useful outside of Prvd 'M Wrong itself;
prefer to specify startup options as a parameter of [`
start(options)`](../providers/start.md).

=== "Luau"

    ```TypeScript
    export type Options = {
      logLevel: "none" | "verbose",
      profiling: boolean
    }
    ```

=== "TypeScript"

    ```TypeScript
    export interface Options {
      logLevel: "none" | "verbose"
      profiling: boolean
    }
    ```

---

## Members

### logLevel `#!lua : "none" | "verbose"`

Configures if Prvd 'M Wrong should log trace information to the console, defaults
to `#!lua "none"`.

### profiling `#!lua : boolean`

Configures if built-in lifecycle events should be profiled with
`debug.setmemorycategory` and `debug.profilebegin`, defaults to whether the
current session is running in Roblox Studio.

---

## Learn More

- [startup tutorial](../../../tutorials/fundamentals/startup.md)
