--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local Lifecycles = require(script.lifecycles)
local Log = require(script.log)
local Modding = require(script.modding)
local Prvd = require(script.prvd)
local Reflect = require(script.reflect)
local Types = require(script.types)

export type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle<Interface>
export type OnInit = Types.OnInit
export type OnStart = Types.OnStart
export type Options = Types.Options
export type Provider<T> = Types.Provider<T>
export type StartupStatus = Types.StartupStatus

if _G.__ohmyprvd__ ~= nil then
  Log.warn("multipleInstalls")
  return _G.__ohmyprvd__
end

local prvd: Types.Prvd = table.freeze {
  version = "VERSION",

  -- Providers API
  awaitStart = Prvd.awaitStart,
  new = Prvd.Provider,
  onStart = Prvd.onStart,
  Provider = Prvd.Provider,
  StartupStatus = Prvd.StartupStatus,
  start = Prvd.start,
  preload = Prvd.preload,
  use = Prvd.use,

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

    defineMetadata = Reflect.defineMetadata,
    getMetadata = Reflect.getMetadata,
    deleteMetadata = Reflect.deleteMetadata,

    registerDependency = Prvd.registerDependency,
  },
}

_G.__ohmyprvd__ = prvd
return prvd
