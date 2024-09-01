<div class="pmwdoc-reference-breadcrumbs">
<a href="../../../">API Reference</a>
<a href="../../">Core</a>
<a href="../">Providers</a>
</div>

<div class="pmwdoc-reference-tags">
<span class="pmwdoc-reference-highlight">enumeration</span>
<span class="pmwdoc-reference-since">since v0.1</span>
</div>

# :octicons-list-ordered-16: StartupStatus

An enumeration of all defined startup status Prvd 'M Wrong will be in.

This enum is not useful outside of Prvd 'M Wrong itself; prefer to work with
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

Indicates that [`#!lua prvd.start()`](start.md) has not been called yet.
Creating a provider is safe.

### startup `#!lua : StartupStatus.startup`

Indicates that `#!lua prvd.start()` has been called, but the startup process has
not finished. Attempting to create a provider will throw an error.

### Ignited `#!lua : StartupStatus.Ignited`

Indicates that the startup process has finished. Attempting to create a provider
will throw an error.

Awaiting threads from [`#!lua prvd.awaitStart()`](await-start.md) and
queued callbacks from [`#!lua prvd.onStart()`](on-start.md) will be
spawned just before the startup status is set to this.
