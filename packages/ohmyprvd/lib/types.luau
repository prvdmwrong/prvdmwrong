--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

export type Error = {
  type: "Error",
  raw: string,
  message: string,
  trace: string,
}

export type PromiseStatus = "Started" | "Resolved" | "Rejected" | "Cancelled"
export type Promise = {
  andThen: (
    self: Promise,
    successHandler: (...any) -> ...any,
    failureHandler: ((...any) -> ...any)?
  ) -> Promise,
  andThenCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> any,
  andThenReturn: (self: Promise, ...any) -> Promise,

  await: (self: Promise) -> (boolean, ...any),
  awaitStatus: (self: Promise) -> (PromiseStatus, ...any),

  cancel: (self: Promise) -> (),
  catch: (self: Promise, failureHandler: (...any) -> ...any) -> Promise,
  expect: (self: Promise) -> ...any,

  finally: (self: Promise, finallyHandler: (status: Status) -> ...any) -> Promise,
  finallyCall: <TArgs...>(self: Promise, callback: (TArgs...) -> ...any, TArgs...) -> Promise,
  finallyReturn: (self: Promise, ...any) -> Promise,

  getStatus: (self: Promise) -> Status,
  now: (self: Promise, rejectionValue: any?) -> Promise,
  tap: (self: Promise, tapHandler: (...any) -> ...any) -> Promise,
  timeout: (self: Promise, seconds: number, rejectionValue: any?) -> Promise,
}

export type Object = { [unknown]: unknown }
export type Pack = { [number]: any, n: number }

export type OnInit = { onInit: (self: unknown) -> Promise? }
export type OnStart = { onStart: (self: unknown) -> () }
export type Lifecycle<Interface = { [any]: any }> = {
  listeners: { Interface },
  method: string,

  fire: (self: Lifecycle<Interface>, ...unknown) -> (),
  register: (self: Lifecycle<Interface>, object: Interface) -> (),
  unregister: (self: Lifecycle<Interface>, object: Interface) -> (),
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
  new: <T>(name: string, provider: T) -> Provider<T>,
  onStart: (callback: () -> ()) -> (),
  Provider: <T>(name: string, provider: T) -> Provider<T>,
  preload: (instances: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
  StartupStatus: {
    Pending: "StartupStatus.Pending",
    Starting: "StartupStatus.Starting",
    Started: "StartupStatus.Started",
  },
  start: (options: {
    logLevel: "none" | "verbose" | nil,
    profiling: boolean?,
  }?) -> (),
  use: <T>(provider: Provider<T>) -> T,

  Lifecycle: (method: string, fire: (self: Lifecycle, ...unknown) -> ()) -> Lifecycle,
  fireConcurrent: (self: Lifecycle, ...unknown) -> (),
  fireSequential: (self: Lifecycle, ...unknown) -> (),
  onMethodRegistered: (method: string, handler: (Object) -> ()) -> (),
  onMethodUnregistered: (method: string, handler: (Object) -> ()) -> (),

  getStartupOptions: () -> Options,
  getStartupStatus: () -> StartupStatus,
  onProviderConstructed: (handler: (Provider<unknown>) -> ()) -> (),
  onProviderUsed: (handler: (Provider<unknown>) -> ()) -> (),
  internal: {
    registerAll: (object: Object) -> (),
    registerMethod: (object: Object, method: string) -> (),
    unregisterMethod: (object: Object, method: string) -> (),

    defineMetadata: (object: unknown, key: string, value: unknown) -> (),
    getMetadata: (object: unknown, key: string) -> unknown?,
    deleteMetadata: (object: unknown, key: string, property: string?) -> (),

    registerDependency: (identifier: string, dependency: Object) -> (),
  },
}

return nil
