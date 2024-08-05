--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local Lifecycles = require("@core/lifecycles")
local Log = require("@core/log")
local Modding = require("@core/modding")
local Prvd = require("@core/prvd")
local Reflection = require("@core/reflection")
local Types = require("@core/types")

export type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle<Interface>
export type OnInit = Types.OnInit
export type OnStart = Types.OnStart
export type Options = Types.Options
export type Provider<T> = Types.Provider<T>
export type StartupStatus = Types.StartupStatus

if _G.ohmyprvd ~= nil then
  Log.warn("multipleInstalls")
  return _G.ohmyprvd :: Types.Prvd
end

local ohmyprvd: Types.PrvdNamespace = table.freeze {
  version = "VERSION",

  -- Providers API
  awaitStart = Prvd.awaitStart,
  onStart = Prvd.onStart,
  StartupStatus = Prvd.StartupStatus,
  start = Prvd.start,
  preload = Prvd.preload,
  use = Prvd.use,
  TSProvider = Prvd.TSProvider,

  -- Lifecycles API
  Lifecycle = Lifecycles.Lifecycle,
  fireConcurrent = Lifecycles.fireConcurrent,
  fireSequential = Lifecycles.fireSequential,
  onLifecycleRegistered = Lifecycles.onLifecycleRegistered,
  onLifecycleUnregistered = Lifecycles.onLifecycleUnregistered,
  onMethodImplemented = Lifecycles.onMethodImplemented,

  -- Modding API
  getStartupOptions = Prvd.getStartupOptions,
  getStartupStatus = Prvd.getStartupStatus,
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

    registerDependency = Prvd.registerDependency,
  },
}

setmetatable(ohmyprvd, {
  __call = function<T>(_, provider: T): Provider<T>
    return Prvd.new(provider)
  end,
})

_G.ohmyprvd = ohmyprvd
return ohmyprvd :: Types.Prvd
