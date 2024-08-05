--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local package = script.Parent
local prvd = require(package.Parent.prvd)
type Provider<T> = prvd.Provider<T>

export type ComponentStreamingMode =
  "ComponentStreamingMode.Disabled"
  | "ComponentStreamingMode.Watching"
  | "ComponentStreamingMode.Contextual"

export type Component<Methods, ExpectedInstance = Instance> = Methods & {
  tag: string?,
  instance: ExpectedInstance,
  instanceGuard: ((Instance) -> (boolean, ...any))?,
  predicate: ((Instance) -> boolean)?,

  warningTimeout: number?,
  streamingMode: ComponentStreamingMode?,

  ancestorBlacklist: { Instance }?,
  ancestorWhitelist: { Instance }?,
}

export type OnComponentAdded = {
  onComponentAdded: (self: prvd.Provider<unknown>, Component<unknown, Instance>, instance: Instance) -> (),
}

export type OnComponentRemoved = {
  onComponentRemoved: (self: prvd.Provider<unknown>, Component<unknown, Instance>, instance: Instance) -> (),
}

return nil
