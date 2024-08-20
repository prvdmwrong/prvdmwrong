<div class="pmwdoc-reference-breadcrumbs">
<a href="../">Reference</a>
</div>

# :octicons-x-circle-16: Errors

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
Cannot start more than once.
```

You attempted to start Prvd 'M Wrong when it has already started.

---

## cannotRegister

```Md
Cannot register provider; `MyProvider.onStart` should be a function.
```

You attempted to register a new provider, but Prvd 'M Wrong caught something wrong.
The error includes a more specific message which can be used to diagnose the
issue. Typically it is one of the following:

- You have frozen the provider table, which prevents dependency injection
- You provided a mismatched type for a built-in method/property

---

## cannotRegisterLifecycle

```Md
Cannot register lifecycle onShutdown; already registered lifecycle.
```

You attempted to create or register a lifecycle, but Prvd 'M Wrong caught
something wrong. The error includes a more specific message which can be used to
diagnose the issue. Typically it is one of the following:

- You did not provide a `method` to listen for
- You did not provide a `fire` handler in the constructor
- A provider tried to register the same lifecycle twice
- A provider has a mismatched type for the lifecycle

---

## compatDeprecated

```Md
Use the `Lifecycle` object or the `@prvdmwrong/lifecycles` package instead of creating `Worker()`s; lifecycles have furthered customizability and hook onto providers, with the latter implementing all workers Lumin Framework offers as lifecycles
```

You used a method from a compatibility package that has a Prvd 'M Wrong
equivalent, which should be used instead. The warning includes a more specific
message.

---

# incompatibleVersion

```Md
An incompatible core Prvd 'M Wrong package was found. Currently version 0.2.0-dev.9, found version 0.2.0-dev.12. Consider updating your installation.
```

A global reference to Prvd 'M Wrong was found, but the referenced package is
not backwards-compatible with the current package. Consider updating to a newer
version for an expanded featureset and improved developer experience.

---

## invalidLoadParent

**Thrown by:** [`prvd.preload`](core/providers/preload.md)

```Md
`preload` must be given an instance
```

`prvd.preload(instances, predicate)` expected you to give it a parent instance
to load from, but you gave it something else.

---

## invalidOnStartCallback

```Md
`onStart` must be given callbacks
```

`prvd.onStart(callback)` expected you to give it a callback to spawn after
startup finishes, but you gave it something else.

---

## invalidRefVersion

```Md
Cannot parse major version from the global Prvd 'M Wrong reference, see if there is a corrupt installation.
```

A global reference to Prvd 'M Wrong was found, but the version of the referenced
package cannot be parsed. As such, Prvd 'M Wrong cannot determine if the
package is backwards compatible.

You should not see this error unless you are using a fork of Prvd 'M Wrong.

---

## luminMissingWorker

```Md
PsotSimulation is not a Lumin Framework worker.
```

You attempted to create a new worker using the Lumin Framework compatibility
layer, but Prvd 'M Wrong cannot determine what event to adapt.

Consider migrating to Prvd 'M Wrong and use the `Lifecycle` object or the
`@prvdmwrong/lifecycles` package for the same functionality as lifecycles.

---

## noPrvd

```Md
Cannot find the `@prvdmwrong/core` package, try requiring the core package earlier so other packages can reference it.
```

You attempted to require another Prvd 'M Wrong package prior to requiring the
core package. As such, the external package cannot find the global Prvd 'M
Wrong reference to use.

Consider requiring the core package earlier so Prvd 'M Wrong can initialize
itself.

---

## onInitError

```Md
Cannot initialize MyProvider; attempted to index nil with 'property'.
```

Prvd 'M Wrong could not finish its initialization lifecycle as a provider threw an
error in it's `:init` method. The error includes a more specific message which
can be used to diagnose the issue.

---

## registerAfterStart

```Md
Cannot register providers after startup.
```

You attempted to register a provider after startup.

Make sure you've preloaded all providers you will use prior to startup, and
that no other module registers a provider after startup.

---

## requireError

```Md
Cannot require ServerScriptService.Providers.MyProvider; Module code did not return exactly one value.
```

You tried to preload a module which threw an error that Prvd 'M Wrong cannot
handle. The error includes a more specific message which can be used to diagnose
the issue.

---

## unknownError

```Md
Unknown error: attempt to call a nil value. This indicates Prvd 'M Wrong isn't reporting errors correctly, please file an issue.
```

Prvd 'M Wrong ran into an error, but cannot associate it with an error message.
This is a fallback error type which shouldn't be seen by end users, because it
indicates that Prvd 'M Wrong is not reporting errors correctly.

---

## usedWasDeprecated

```Md
`prvd.use(callback)` was deprecated, specify the provider directly instead.
```

You attempted to `use` another provider in Prvd 'M Wrong 0.2, which deprecates
it in favor of specifying the provider as a member.
