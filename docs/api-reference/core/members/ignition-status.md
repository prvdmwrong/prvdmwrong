<div class="ompdoc-api-breadcrumbs">
<a href="../../">Oh My Prvd</a>
<a href="../">Core</a>
</div>

<div class="ompdoc-api-tags">
<span>enumeration</span>
<span>since v0.1</span>
</div>

# IgnitionStatus

An enumeration of all defined ignition status Oh My Prvd will be in.

This enum is not useful outside of Oh My Prvd itself; prefer to work with
[`awaitIgnition()`](await-ignition.md) and [`
onIgnition(callback)`](on-ignition.md)

=== "Luau"

    ```Lua
    prvd.IgnitionStatus = {
      Pending = "IgnitionStatus.Pending",
      Ignition = "IgnitionStatus.Ignition",
      Ignited = "IgnitionStatus.Ignited"
    }
    ```

=== "TypeScript"

    ```TypeScript
    export enum IgnitionStatus {
      Pending = "IgnitionStatus.Pending",
      Ignition = "IgnitionStatus.Ignition",
      Ignited = "IgnitionStatus.Ignited"
    }
    ```

## Items

### Pending `#!lua : IgnitionStatus.Pending`

Indicates that [`#!lua prvd.ignite()`](ignite.md) has not been called yet. Calls
to [`#!lua prvd.use()`](use.md) and [`#!lua prvd.Provider()`](provider.md) are
safe.

### Ignition `#!lua : IgnitionStatus.Ignition`

Indicates that `#!lua prvd.ignite()` has been called, but the ignition process
has not finished. Calls to `#!lua prvd.use()` and `#!lua prvd.Provider()` will
throw an error.

### Ignited `#!lua : IgnitionStatus.Ignited`

Indicates that the ignition process has finished. Calls to `#!lua prvd.use()`
and `#!lua prvd.Provider()` will throw an error.

Awaiting threads from [`#!lua prvd.awaitIgnition()`](await-ignition.md) and
queued callbacks from [`#!lua prvd.onIgnition()`](on-ignition.md) will be
spawned just before the ignition status is set to this.
