local Lifecycles = require("core/lifecycles")
local nicknames = require("core/utils/nicknames")
local root = require("core/providers/root")
local types = require("core/types")

export type Lifecycle<Args...> = types.Lifecycle<Args...>
export type Provider<Self> = types.Provider<Self>
export type Root = types.Root
export type RootStatus = types.RootStatus

local prvd = table.freeze {
  version = _G.BUILD_VERSION,

  -- Core API
  root = root,
  nameOf = nicknames.nameOf,

  -- Lifecycle API
  lifecycle = Lifecycles.lifecycle,
  fireConcurrent = Lifecycles.fireConcurrent,
  fireSequential = Lifecycles.fireSequential,
  providerInit = Lifecycles.providerInit,
  providerStart = Lifecycles.providerStart,
  providerStop = Lifecycles.providerStop,

  -- Net API
  netRoot = root(),

  -- Component API
  componentRoot = root(),
}

setmetatable(prvd, {
  __call = function<Self>(_: unknown, provider: Self): Provider<Self>
    error("not implemented")
  end,
})

return prvd
