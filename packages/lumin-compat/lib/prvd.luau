--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

type Pack = { [number]: any, n: number }
type Object = { [unknown]: unknown }

type Error = {
  type: "Error",
  raw: string,
  message: string,
  trace: string,
}

export type OnInit = { onInit: (self: unknown) -> () }
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
  name: string?,

  onInit: (self: Provider<T>) -> ()?,
  onStart: (self: Provider<T>) -> ()?,
  [{ __PROVIDER_KEY__: never? }]: Provider<T>,
}

type PrvdNamespace = {
  version: string,

  awaitStart: () -> (),
  onStart: (callback: () -> ()) -> (),
  new: <T>(provider: T) -> Provider<T>,
  preload: (instances: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> { unknown },
  Provider: (options: { loadOrder: number? }?) -> <T>(provider: T) -> (),
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
  onLifecycleRegistered: (method: string, handler: (Object) -> ()) -> (),
  onLifecycleUnregistered: (method: string, handler: (Object) -> ()) -> (),

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
    deleteMetadata: (object: unknown, key: string) -> (),

    registerDependency: (identifier: string, dependency: Object) -> (),
  },
}

type Prvd = typeof(setmetatable(
  {} :: PrvdNamespace,
  {} :: {
    __call: <T>(_: any, provider: T) -> Provider<T>,
  }
))

local prvd = _G.prvdmwrong
assert(prvd ~= nil, "cannot find core prvdmwrong package")
return prvd :: Prvd
