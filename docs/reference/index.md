# Reference

This section provides detailed reference documentation for working with Oh My
Prvd. For an introduction to Prvd 'M Wrong, see the [Learn
section.](../tutorials/index.md)

!!! warning "Under construction"

    The reference is under construction - information may be incomplete or
    missing.

---

## Types

For convenience, API pages will have it's corresponding type member annotated
in both Luau and TypeScript:

=== "Luau"

    ```Lua
    function prvd.start(
      options: {
        logLevel: "none" | "verbose" | nil,
        profiling: boolean?,
      }?
    ): ()
    ```

=== "TypeScript"

    ```TypeScript
    export const start: (
      options: Partial<Options> = {
        logLevel: "none",
        profiling: RunService.IsStudio(),
      }
    ) => void
    ```

While these type annotations are kept to be accurate, it is ultimately
psuedo-code included as developer aid. For fully accurate and syntactically
valid type information, please refer to the source code directly.

---

## Conventions

The reference uses several conventions, explained below:

<div class="grid cards" markdown>

- :octicons-package-16: **Constructors**

    The cube icon is denotes a constructor, a special type of function for
    creating and initializing objects.

- :octicons-list-ordered-16: **Enumerations**

      The list icon denotes an enumeration, which represent a set of named
      constants.

- :octicons-code-16: **Functions**

    The code icon denotes a function, fundamental primitives that runs a
    specific task.

- :octicons-workflow-16: **Hooks**

    The branch icon denotes a hook, a special type of function that allows you
    to "hook into" Prvd 'M Wrong to perform side effects.

- :octicons-checklist-16: **Types**

    The checklist icon denotes a type, which defines the interface and possible
    values of an object.

</div>

---

## Packages

The reference is broken down into functional packages.

### Core

Details the `prvdmwrong` package, which implements provider primitives and
everything needed to bootstrap a game:

- [Providers](core/providers/index.md) · Create and use game providers
- [Lifecycles](core/lifecycles/index.md) · Create lifecycle methods and events
- [Modding](core/modding/index.md) · Extend Prvd 'M Wrong's core functionality
- [Internal](core/internal/index.md) · Lower level primitives for library
  authors
- [Types](core/types/index.md) · Types exported by the core package

### Lifecycles

Details the `prvdmwrong-lifecycles` package, which implements a "small" amount of
lifecycle events.

- [Runtime](lifecycles/runtime/index.md) · Lifecycle methods for the Roblox
  runtime
- [Players](lifecycles/players/index.md) · Lifecycle methods for the Players
  service

### Net

Details the `prvdmwrong-net` package, which implements networking primitives for
providers.

??? warning "Unreleased"

    This package is unreleased, as such no documentation is available at this
    time.

### Components

Details the `prvdmwrong-components` package, which implements a component system
for providers.

??? warning "Unreleased"

    This package is unreleased, as such no documentation is available at this
    time.

### Debugger

Details the `prvdmwrong-debugger` package, which implements a quality of life
debugger for working with Prvd 'M Wrong.

??? warning "Unreleased"

    This package is unreleased, as such no documentation is available at this
    time.

### Compatibility Packages

To transition older codebases, Prvd 'M Wrong has compatibility packages for
several frameworks.

These are drop in replacements for entire frameworks that hook onto the Prvd 'M
Wrong API. Just change where you require the original framework and let Prvd 'M
Wrong handle the rest.

- `prvdmwrong/knit-compat` · Knit compatibility layer
- `prvdmwrong/lumin-compat` · Lumin Framework compatibility layer
- `prvdmwrong/sapphire-compat` · Sapphire compatibility layer
- `prvdmwrong/catwork-compat` · Catwork compatibility layer
- `rbxts-prvdmwrong-flamework` · Transform Flamework v1 projects into Prvd 'M
  Wrong
