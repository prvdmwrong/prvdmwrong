<div class="ompdoc-reference-breadcrumbs">
<a href="../../../">Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="ompdoc-reference-tags">
<span>enumeration</span>
<span>since v0.1</span>
</div>

# StartupStatus

An enumeration of all defined startup status Oh My Prvd will be in.

This enum is not useful outside of Oh My Prvd itself; prefer to work with
[`awaitStart()`](await-start.md) and [`
onStart(callback)`](on-start.md)

=== "Luau"

    ```Lua
    prvd.StartupStatus = {
      Pending = "IgnitionStatus.Pending",
      startup = "IgnitionStatus.startup",
      Ignited = "IgnitionStatus.Ignited"
    }
    ```

=== "TypeScript"

    ```TypeScript
    export enum StartupStatus {
      Pending = "IgnitionStatus.Pending",
      startup = "IgnitionStatus.startup",
      Ignited = "IgnitionStatus.Ignited"
    }
    ```

## Items

### Pending `#!lua : StartupStatus.Pending`

Indicates that [`#!lua prvd.start()`](start.md) has not been called yet. Calls
to [`#!lua prvd.use()`](use.md) and [`#!lua prvd.Provider()`](provider.md) are
safe.

### startup `#!lua : StartupStatus.startup`

Indicates that `#!lua prvd.start()` has been called, but the startup process
has not finished. Calls to `#!lua prvd.use()` and `#!lua prvd.Provider()` will
throw an error.

### Ignited `#!lua : StartupStatus.Ignited`

Indicates that the startup process has finished. Calls to `#!lua prvd.use()`
and `#!lua prvd.Provider()` will throw an error.

Awaiting threads from [`#!lua prvd.awaitStart()`](await-start.md) and
queued callbacks from [`#!lua prvd.onStart()`](on-start.md) will be
spawned just before the startup status is set to this.
