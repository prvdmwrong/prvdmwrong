# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Added actual types for `@rbxts/ohmyprvd`
- Added missing error messages
- Added `onProviderConstructed` and `onProviderUsed` modding hooks
- Added reflection API with `defineMetadata`, `deleteMetadata`, and
  `getMetadata`

### Changed

- Renamed `implementMethod` to `onMethodImplemented` to align it more with
  modding hooks

## 0.1.0-alpha

- Initial release
