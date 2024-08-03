--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT

export type UnknownProvider = Provider<unknown>

export type Error = {
  type: "Error",
  raw: string,
  message: string,
  trace: string,
}

export type OnInit = { onInit: (self: unknown) -> Promise? }
export type OnStart = { onStart: (self: unknown) -> () }

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
export type Pack = { [number]: any, n: number }

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
  getIgnitionOptions: () -> Options,

  defineMetadata: (object: unknown, key: string, value: unknown) -> (),
  getMetadata: (object: unknown, key: string) -> unknown?,
  deleteMetadata: (object: unknown, key: string, property: string?) -> (),

  preload: (parent: Instance, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
}

return nil
