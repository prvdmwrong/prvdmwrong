<div class="pmwdoc-reference-breadcrumbs">
<a href="../">Reference</a>
</div>

# :octicons-x-circle-16: Error Messages

Prvd 'M Wrong attaches an error ID with every console log message. This is used to
uniquely identify what kind of error or message you're seeing.

Use the search box below to paste in or type an error ID, and it will scroll to
the details for you.

<input
 id="pmwdoc-error-box"
 class="md-input md-input--stretch"
 placeholder="Type or paste an error ID here..."
/>

<script src="../../assets/javascripts/error-msgs.js" defer></script>

---

## alreadyStarted

```Md
cannot start more than once
```

**Thrown by:** [`prvd.start(options)`](core/providers/start.md)

You attempted to start Prvd 'M Wrong when it has already started.

---

## cannotRegister

```Md
cannot register provider; `MyProvider.onStart` should be a function
```

**Thrown by:** [`prvd.Provider`](core/providers/provider.md),
[`prvd.new`](core/providers/provider.md)

You attempted to register a new provider, but Prvd 'M Wrong caught something wrong.
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

## invalidLoadParent

**Thrown by:** [`prvd.preload`](core/providers/preload.md)

```Md
preload must be given an instance
```

`prvd.preload(instances, predicate)` expected you to give it a parent instance
to load from, but you gave it something else.

---

## invalidOnIgnitionCallback

```Md
`onStart` must be given callbacks
```

**Thrown by:** [`prvd.onStart`](core/providers/on-start.md)

`prvd.onStart(callback)` expected you to give it a callback to spawn after
startup finishes, but you gave it something else.

---

## registerAfterIgnition

```Md
cannot register providers after startup
```

**Thrown by:** [`prvd.Provider`](core/providers/provider.md),
[`prvd.new`](core/providers/provider.md)

You attempted to register a provider after startup.

Make sure you've preloaded all providers you will use prior to startup, and
that no other module registers a provider after startup.

---

## onInitError

**Thrown by:** [`prvd.start`](core/providers/start.md)

```Md
cannot initialize MyProvider; attempted to index nil with 'property'
```

Prvd 'M Wrong could not finish its initialization lifecycle as a provider threw an
error in it's `:init` method. The error includes a more specific message which
can be used to diagnose the issue.

---

## requireError

```Md
cannot require ServerScriptService.Providers.MyProvider; Module code did not return exactly one value
```

**Thrown by:** [`prvd.preload`](core/providers/preload.md),

`prvd.preload(instances, predicate)` loaded a module which threw an error that
Prvd 'M Wrong cannot handle. The error includes a more specific message which can
be used to diagnose the issue.

---

## unknown

```Md
unknown error: attempt to call a nil value
help: this indicates Prvd 'M Wrong isn't reporting errors correctly, please file an issue
```

Prvd 'M Wrong ran into an error, but cannot associate it with an error message.
This is a fallback error type which shouldn't be seen by end users, because it
indicates that Prvd 'M Wrong is not reporting errors correctly.

---

## useAfterStartup

```Md
cannot use other providers after startup
```

**Thrown by:** [`prvd.use`](core/providers/use.md)

You tried to `use()` another provider after Prvd 'M Wrong started.

Make sure every provider explicitly `use()`s all providers it needs. This lets
Prvd 'M Wrong figure out a corresponding load order.

---

## usedBeforeStartup

```Md
cannot use provider "MyProvider" prior to startup
help: prvdmwrong will inject the dependency for you during runtime, its safe to use the provider inside a lifecycle method
```

You tried to access the contents of a `use()`d provider prior to startup.

Prvd 'M Wrong will inject the dependency for you when ignited and figure out a
corresponding load order. Make sure when you use another provider, you're
using it from a lifecycle method.
