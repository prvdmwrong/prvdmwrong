--!strict
--[[
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local prvd = require("lifecycles/prvd")

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
