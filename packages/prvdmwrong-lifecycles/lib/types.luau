--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

export type OnPreSimulation = {
  onPreSimulation: (self: Provider<unknown>, number) -> (),
}

export type OnPostSimulation = {
  onPostSimulation: (self: Provider<unknown>, number) -> (),
}

export type OnPreRender = {
  onPreRender: (self: Provider<unknown>, number) -> (),
}

export type OnShutdown = {
  onShutdown: (self: Provider<unknown>) -> (),
}

export type OnPlayerAdded = {
  onPlayerAdded: (self: Provider<unknown>, Player) -> (),
}

export type OnPlayerRemoving = {
  onPlayerRemoving: (self: Provider<unknown>, Player) -> (),
}

export type StartupStatus = "StartupStatus.Pending" | "StartupStatus.Starting" | "StartupStatus.Started"

export type Options = {
  logLevel: "none" | "verbose",
  profiling: boolean,
}

export type Provider<T> = T & {
  loadOrder: number?,

  onInit: (self: Provider<T>) -> ()?,
  onStart: (self: Provider<T>) -> ()?,
}

export type Prvd = {
  version: string,

  awaitStart: () -> (),
  start: (options: {
    logLevel: "none" | "verbose" | nil,
    profiling: boolean?,
  }?) -> (),
  StartupStatus: {
    Pending: "StartupStatus.Pending",
    Starting: "StartupStatus.Starting",
    Startup: "StartupStatus.Started",
  },
  new: <T>(name: string, provider: T) -> Provider<T>,
  onStart: (callback: () -> ()) -> (),
  Provider: <T>(name: string, provider: T) -> Provider<T>,
  use: <T>(provider: Provider<T>) -> T,

  onMethodImplemented: (method: string, handler: (Provider<unknown>) -> ()) -> (),
  onProviderConstructed: (handler: (Provider<unknown>) -> ()) -> (),
  onProviderUsed: (handler: (Provider<unknown>) -> ()) -> (),
  getStartupOptions: () -> Options,
  getStartupStatus: () -> StartupStatus,

  defineMetadata: (object: unknown, key: string, value: unknown) -> (),
  getMetadata: (object: unknown, key: string) -> unknown?,
  deleteMetadata: (object: unknown, key: string, property: string?) -> (),

  preload: (parent: Instance, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
}

return nil
