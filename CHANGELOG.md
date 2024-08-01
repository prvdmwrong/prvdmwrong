# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added `prvd.getStartupStatus` for retrieving the status of `prvd.start`

### Changed

- Anything related to ignition has been renamed to startup:

  - `prvd.ignite` has been renamed to `prvd.start`
  - `prvd.IgnitionStatus` has been renamed to `prvd.StartupStatus`
  - `prvd.awaitIgnition` has been renamed to `prvd.awaitStart`
  - `prvd.onIgnition` has been renamed to `prvd.onStart`
  - `prvd.awaitIgnition` has been renamed to `prvd.awaitStart`
  - `prvd.getIgnitionOptions` has been renamed to `prvd.getStartupOptions`

- Changed error logging internally

### Fixed

- Fixed onInit & onStart methods not being fired during startup
- Oh My Prvd now respects frozen tables while resolving dependencies
- Log messages now are formatted correctly

## 0.1.1-alpha

### Added

- Added actual types for `@rbxts/ohmyprvd`
- Added missing error messages
- Added `onProviderConstructed` and `onProviderUsed` modding hooks
- Added `matchesName` utility function as a predicate for `loadX` APIs
- Exposed reflection API with `defineMetadata`, `deleteMetadata`, and
  `getMetadata`
- Added `ohmyprvd-lifecycles` package which implements lifecycle events for the
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
  as a new `ohmyprvd-lifecycles` package
  - These lifecycle events aren't necessary and can be considered bloat, and
    should preferably be extracted as a package for adding more built-in
    lifecycle events

## 0.1.0-alpha

- Initial release
