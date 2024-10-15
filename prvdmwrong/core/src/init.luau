local Lifecycles = require("@core/lifecycles")
local Providers = require("@core/providers")

export type Lifecycle<Args...> = Lifecycles.Lifecycle<Args...>
export type Provider<Self> = Providers.Provider<Self>
export type Root = Providers.Root
export type RootStatus = Providers.RootStatus

local prvd = table.freeze {
  version = _G.PRVDMWRONG_VERSION,

  -- Core API
  root = Providers.root,
  prvd = Providers.prvd,

  -- Lifecycle API
  lifecycle = Lifecycles.lifecycle,
  fireConcurrent = Lifecycles.fireConcurrent,
  fireSequential = Lifecycles.fireSequential,

  -- Net API
  netRoot = Providers.root(),

  -- Component API
  componentRoot = Providers.root(),
}

setmetatable(prvd, {
  __call = function<Self>(_: unknown, provider: Self): Provider<Self>
    error("not implemented")
  end,
})

return prvd
