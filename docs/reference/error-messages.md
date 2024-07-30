<div class="ompdoc-api-breadcrumbs">
<a href="../">Oh My Prvd</a>
</div>

# :octicons-x-circle-24: Error Messages

Oh My Prvd attaches an error ID with every console log message. This is used to
uniquely identify what kind of error or message you're seeing.

For example, given the message below, the error ID would be
`usedBeforeIgnition`.

```Txt
[ohmyprvd error(usedBeforeIgnition)]: cannot use provider "MyProvider" prior to ignition
```

Use the search box below to paste in or type an error ID, and it will scroll to
the details for you.

<input
 id="ompdoc-error-box"
 class="md-input md-input--stretch"
 placeholder="Type or paste an error ID here..."
/>

<script src="../../assets/javascripts/error-msgs.js" defer></script>

---

## alreadyIgnited

```Md
cannot ignite more than once
```

**Thrown by:** [`prvd.ignite`](core/providers/ignite.md)

You attempted to reignite Oh My Prvd when it has already been ignited.

---

## cannotRegister

```Md
cannot register provider; `MyProvider.init` should be a function
```

**Thrown by:** [`prvd.Provider`](core/providers/provider.md),
[`prvd.new`](core/providers/provider.md)

You attempted to register a new provider, but Oh My Prvd caught something wrong.
The error includes a more specific message which can be used to diagnose the
issue. Typically it is one of the following:

- A provider of the same name was already registered
- You have frozen the provider table, which prevents dependency injection
- You provided a mismatched type for a built-in method/property
- You forgot to include a non-empty string as a `name`

---

## cannotUseNonProvider

```Md
`use()` must be given a provider
```

**Thrown by:** [`prvd.use`](core/providers/use.md)

You attempted to `use()` an object that was not registered as a provider.

---

## initError

**Thrown by:** [`prvd.ignite`](core/providers/ignite.md)

```Md
cannot initialize MyProvider; attempted to index nil with 'property'
```

Oh My Prvd could not finish its initialization lifecycle as a provider threw an
error in it's `:init` method. The error includes a more specific message which
can be used to diagnose the issue.

---

## invalidLoadParent

**Thrown by:** [`prvd.loadChildren`](core/loader/load-children.md),
[`prvd.loadDescendants`](core/loader/load-descendants.md)

```Md
loadX must be given an instance
```

`loadChildren` and `loadDescendants` expected you to give it a parent instance
to load from, but you gave it something else.

---

## invalidOnIgnitionCallback

```Md
`onIgnition` must be given callbacks
```

**Thrown by:** [`prvd.onIgnition`](core/providers/on-ignition.md)

`onIgnition` expected you to give it a callback to spawn after ignition
finishes, but you gave it something else.

---

## registerAfterIgnition

```Md
cannot register providers after ignition
```

**Thrown by:** [`prvd.Provider`](core/providers/provider.md),
[`prvd.new`](core/providers/provider.md)

You attempted to register a provider after ignition.

Make sure you've preloaded all providers you will use prior to ignition, and
that no other module registers a provider after ignition.

---

## requireError

```Md
cannot require ServerScriptService.Providers.MyProvider; Module code did not return exactly one value
```

**Thrown by:** [`prvd.loadChildren`](core/loader/load-children.md),
[`prvd.loadDescendants`](core/loader/load-descendants.md)

`loadChildren` and `loadDescendants` loaded a module which threw an error that
Oh My Prvd cannot handle. The error includes a more specific message which can
be used to diagnose the issue.

---

## serverRenderLifecycle

```Md
cannot use `:render` lifecycle from the server
```

**Thrown by:** [`prvd.Provider`](core/providers/provider.md),
[`prvd.new`](core/providers/provider.md)

You included a `:render` lifecycle method in one of your providers on the
server. This is undesirable as the server cannot access
`RunService.RenderStepped`.

---

## unknown

```Md
unknown error: attempt to call a nil value
help: this indicates oh my prvd isn't reporting errors correctly, please file an issue
```

Oh My Prvd ran into an error, but cannot associate it with an error message.
This is a fallback error type which shouldn't be seen by end users, because it
indicates that Oh My Prvd is not reporting errors correctly.

??? note "Note on Oh My Prvd's alpha release"

    Oh My Prvd may have reported an error message that has not been registered
    yet. If the message just uses `camelCase` and reads as a lint error, it's a
    missing error message and should be reported as an issue.

---

## useAfterIgnition

```Md
cannot use other providers after ignition
```

**Thrown by:** [`prvd.use`](core/providers/use.md)

You tried to `use()` another provider after ignition started.

Make sure every provider explicitly `use()`s all providers it needs. This lets
Oh My Prvd figure out a corresponding load order.

---

## usedBeforeIgnition

```Md
cannot use provider "MyProvider" prior to ignition
help: ohmyprvd will inject the dependency for you during runtime, its safe to use the provider inside a lifecycle method
```

You tried to access the contents of a `use()`d provider prior to ignition.

Oh My Prvd will inject the dependency for you when ignited and figure out a
corresponding load order. Make sure when you use another provider, you're
using it from a lifecycle method.
