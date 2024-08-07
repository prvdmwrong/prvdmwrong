--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local Lifecycles = require("@core/lifecycles")
local Log = require("@core/log")
local Modding = require("@core/modding")
local Providers = require("@core/providers")
local Reflection = require("@core/modding/reflection")
local Types = require("@core/types")

export type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle<Interface>
export type OnInit = Types.OnInit
export type OnStart = Types.OnStart
export type Options = Types.Options
export type Provider<T> = Types.Provider<T>
export type StartupStatus = Types.StartupStatus

if _G.prvdmwrong ~= nil then
  Log.warn("multipleInstalls")
  return _G.prvdmwrong :: Types.Prvd
end

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
    registerAll = Lifecycles.registerAll,
    registerMethod = Lifecycles.registerMethod,
    unregisterMethod = Lifecycles.unregisterMethod,

    defineMetadata = Reflection.defineMetadata,
    getMetadata = Reflection.getMetadata,
    deleteMetadata = Reflection.deleteMetadata,

    registerDependency = Providers.registerDependency,
  },
}

setmetatable(prvd, {
  __call = function<T>(_, provider: T): Provider<T>
    return Providers.new(provider)
  end,
})

_G.prvdmwrong = prvd
return prvd :: Types.Prvd
