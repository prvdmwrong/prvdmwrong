--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

-- FIXME: doing this for figuring out a possible API
--!nolint LocalUnused
--#selene: allow(unused_variable)

local package = script.Parent
local prvd = require(package.Parent.prvd)
local types = require(package.types)

export type Component<T> = types.Component<T>
export type ComponentStreamingMode = types.ComponentStreamingMode
export type OnComponentAdded = types.OnComponentAdded
export type OnComponentRemoved = types.OnComponentRemoved
type Provider<T> = prvd.Provider<T>

local ComponentStreamingMode = table.freeze {
  Disabled = "ComponentStreamingMode.Disabled" :: "ComponentStreamingMode.Disabled",
  Watching = "ComponentStreamingMode.Watching" :: "ComponentStreamingMode.Watching",
  Contextual = "ComponentStreamingMode.Contextual" :: "ComponentStreamingMode.Contextual",
}

local components: Component<unknown> = {}
local componentAdded: { [Provider<OnComponentAdded>]: true } = {}
local componentRemoved: { [Provider<OnComponentRemoved>]: true } = {}

local ComponentsProvider = {}
type Self = typeof(ComponentsProvider)
ComponentsProvider.ComponentStreamingMode = ComponentStreamingMode
ComponentsProvider.loadOrder = 0

function ComponentsProvider.Component<T>(component: T): Component<T>
  error("not implemented")
end

function ComponentsProvider.attributes<T>(
  defaults: T & { [string]: any },
  typeguards: { [string]: (unknown) -> (boolean, ...unknown) }
): T
  error("not implemented")
end

function ComponentsProvider.onInit(self: Self)
  -- WIP
end

function ComponentsProvider.onStart(self: Self)
  -- WIP
end

function ComponentsProvider.awaitComponent(self: Self, component: Component<unknown>, instance: Instance)
  error("not implemented")
end

function ComponentsProvider.hasComponent(self: Self, component: Component<unknown>, instance: Instance): boolean
  error("not implemented")
end

function ComponentsProvider.addComponent(self: Self, component: Component<unknown>, instance: Instance)
  error("not implemented")
end

function ComponentsProvider.removeComponent(self: Self, component: Component<unknown>, instance: Instance)
  error("not implemented")
end

prvd.onMethodImplemented("onComponentAdded", function(provider: any)
  componentAdded[provider] = true
end)

prvd.onMethodImplemented("onComponentRemoved", function(provider: any)
  componentRemoved[provider] = true
end)

return prvd.new("prvdmwrong@ComponentsProvider", ComponentsProvider)
