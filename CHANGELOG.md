# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `prvd.getStartupStatus` for retrieving the status of `prvd.start`
- Added `prvd.preload(instances, predicate)` utility API in favor of
  `prvd.loadX` functions
- Added `__call` shorthand for `prvd.new`:

  ```Lua
  local ReplicatedStorage = game:GetService("ReplicatedStorage")
  local prvd = require(ReplicatedStorage.Packages.prvdmwrong)

  local MyProvider = {}

  function MyProvider:onStart()
    print("Yo")
  end

  return prvd(MyProvider)
  ```

- Added `@Provider(options)` decorator for TypeScript:

  ```TypeScript
  import { Provider, type OnStart } from "@rbxts/prvdmwrong"

  @Provider({ loadOrder: 0 })
  export class MyProvider implements OnStart {
    /** @hidden */
    public onStart() {
      print("Yo")
    }
  }
  ```

- First class support for custom lifecycle methods:
  - Added `prvd.Lifecycle` and `Lifecycle<Interface>` primitives for lifecycle
    methods
  - Added `prvd.onMethodRegistered` and `prvd.onMethodUnregistered`
  - Added `prvd.fireConcurrent` and `prvd.fireSequential` handlers for lifecycle
    methods, the former spawns all listeners, the latter runs all listeners
    sequentially
- Added type exports for `prvdmwrong-lifecycles`
- Added `onPreAnimation` lifecycle for `prvdmwrong-lifecycles`
- Added `internal` field to exports for lower level primitives
  - Added `prvd.registerDependency` utility for injecting your own dependencies
- Initial release of `prvdmwrong-components`
- Initial release of `prvdmwrong-net`

### Changed

- `prvd.new` no longer needs a name field and falls back to a random hash
  - Providers can be named by specifying a `name` field
- Anything related to ignition has been renamed to startup:

  - `prvd.ignite` has been renamed to `prvd.start`
  - `prvd.IgnitionStatus` has been renamed to `prvd.StartupStatus`
  - `prvd.awaitStart` has been renamed to `prvd.awaitStart`
  - `prvd.onStart` has been renamed to `prvd.onStart`
  - `prvd.awaitStart` has been renamed to `prvd.awaitStart`
  - `prvd.getIgnitionOptions` has been renamed to `prvd.getStartupOptions`

- Changed error logging internally

### Deprecated

- Deprecated `prvd.onMethodImplemented`, use `prvd.onMethodRegistered` for
  observing lifecycle methods or `prvd.Lifecycle` to implement a lifecycle
  method
- Deprecated `prvd.use`, specify providers directly instead

### Removed

- Removed `prvd.loadChildren(parent, predicate)` and
  `prvd.loadDescendants(parent, predicate)`, use `prvd.preload(instances,
  predicate)` instead

### Fixed

- Fixed onInit & onStart methods not being fired during startup
- Prvd 'M Wrong now respects frozen tables while resolving dependencies
- Log messages now are formatted correctly

## 0.1.1-alpha

### Added

- Added actual types for `@rbxts/prvdmwrong`
- Added missing error messages
- Added `onProviderConstructed` and `onProviderUsed` modding hooks
- Added `matchesName` utility function as a predicate for `loadX` APIs
- Exposed reflection API with `defineMetadata`, `deleteMetadata`, and
  `getMetadata`
- Added `prvdmwrong-lifecycles` package which implements lifecycle events for the
  following:

  - `:onPostSimulation(dt: number)` runs every `RunService.PostSimulation`
  - `:onPreSimulation(dt: number)` runs every `RunService.PreSimulation`
  - `:onPreRender(dt: number)` runs every `RunService.PreRender`
  - `:onPlayerAdded(player: Player)` runs every `Player.PlayerAdded`
  - `:onPlayerLeaving(player: Player)` runs every `Player.PlayerLeaving`
  - `:onShutdown()` binds to `game:BindToClose` for games and `plugin.Unloading`
    for plugins

### Changed

- Renamed `implementMethod` to `onMethodImplemented` to align it more with
  modding hooks
- Renamed the `:init` and `:start` lifecycles to `:onInit` and `:onStart` to
  clarify its a lifecycle event

### Removed

- Removed `:heartbeat`, `:step`, `:render` from the core package to be extracted
  as a new `prvdmwrong-lifecycles` package
  - These lifecycle events aren't necessary and can be considered bloat, and
    should preferably be extracted as a package for adding more built-in
    lifecycle events

## 0.1.0-alpha

- Initial release
