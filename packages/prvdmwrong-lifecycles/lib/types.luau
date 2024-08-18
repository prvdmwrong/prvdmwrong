--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local prvd = require("prvdmwrong-lifecycles/prvd")

export type OnPreSimulation = {
  onPreSimulation: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnPostSimulation = {
  onPostSimulation: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnPreAnimation = {
  onPreAnimation: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnPreRender = {
  onPreRender: (self: prvd.Provider<unknown>, number) -> (),
}

export type OnShutdown = {
  onShutdown: (self: prvd.Provider<unknown>) -> (),
}

export type OnPlayerAdded = {
  onPlayerAdded: (self: prvd.Provider<unknown>, Player) -> (),
}

export type OnPlayerRemoving = {
  onPlayerRemoving: (self: prvd.Provider<unknown>, Player) -> (),
}

return nil
