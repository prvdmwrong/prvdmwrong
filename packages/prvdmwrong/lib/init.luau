--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local Types = require("prvdmwrong/types")
local log = require("prvdmwrong/utils/log")

do
  if _G.prvdmwrong ~= nil then
    log.warn("multipleInstalls")
    return _G.prvdmwrong :: Types.Prvd
  end
end

local Lifecycles = require("prvdmwrong/lifecycles")
local Modding = require("prvdmwrong/modding")
local Providers = require("prvdmwrong/providers")
local Reflection = require("prvdmwrong/modding/reflection")

export type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle<Interface>
export type OnInit = Types.OnInit
export type OnStart = Types.OnStart
export type Options = Types.Options
export type Provider<T> = Types.Provider<T>
export type StartupStatus = Types.StartupStatus

local prvd: Types.PrvdNamespace = table.freeze {
  version = "VERSION",

  -- Providers API
  awaitStart = Providers.awaitStart,
  new = Providers.new,
  onStart = Providers.onStart,
  Provider = Providers.Provider,
  StartupStatus = Providers.StartupStatus,
  start = Providers.start,
  preload = Providers.preload,
  use = Providers.use,

  -- Lifecycles API
  Lifecycle = Lifecycles.Lifecycle,
  fireConcurrent = Lifecycles.fireConcurrent,
  fireSequential = Lifecycles.fireSequential,
  onLifecycleRegistered = Lifecycles.onLifecycleRegistered,
  onLifecycleUnregistered = Lifecycles.onLifecycleUnregistered,
  onMethodImplemented = Lifecycles.onMethodImplemented,

  -- Modding API
  getStartupOptions = Providers.getStartupOptions,
  getStartupStatus = Providers.getStartupStatus,
  onProviderConstructed = Modding.onProviderConstructed,
  onProviderUsed = Modding.onProviderUsed,

  -- Internal API
  internal = table.freeze {
    implementAll = Lifecycles.implementAll,
    implementMethod = Lifecycles.implementMethod,
    unimplementMethod = Lifecycles.unimplementMethod,

    defineMetadata = Reflection.defineMetadata,
    getMetadata = Reflection.getMetadata,
    deleteMetadata = Reflection.deleteMetadata,

    registerDependency = Providers.registerDependency,
  },
}

do
  _G.prvdmwrong = prvd
  setmetatable(prvd, {
    __call = function<T>(_, provider: T): Provider<T>
      return Providers.new(provider)
    end,
  })
end

return prvd :: Types.Prvd
