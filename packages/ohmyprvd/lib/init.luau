--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT

local modding = require(script.mods)
local prvd = require(script.prvd)
local reflect = require(script.reflect)
local types = require(script.types)
local utils = require(script.utils)

export type IgnitionStatus = types.IgnitionStatus
export type Options = types.Options
export type Provider<T> = types.Provider<T>

local prvd: types.Prvd = table.freeze {
  version = "0.2.0-dev.2",

  -- Core API
  awaitStart = prvd.awaitStart,
  new = prvd.Provider,
  onStart = prvd.onStart,
  Provider = prvd.Provider,
  StartupStatus = prvd.StartupStatus,
  start = prvd.start,
  use = prvd.use,

  -- Modding API
  getStartupOptions = prvd.getStartupOptions,
  getStartupStatus = prvd.getStartupStatus,
  implementAllMethods = modding.implementAllMethods,
  onMethodImplemented = modding.onMethodImplemented,
  onProviderConstructed = modding.onProviderConstructed,
  onProviderUsed = modding.onProviderUsed,

  -- Reflection API
  defineMetadata = reflect.defineMetadata,
  getMetadata = reflect.getMetadata,
  deleteMetadata = reflect.deleteMetadata,

  -- Utility APIs
  preload = utils.preload,
}

return prvd
