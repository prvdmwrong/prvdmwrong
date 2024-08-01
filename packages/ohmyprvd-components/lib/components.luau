--!strict
--!nolint LocalShadow

--[[

  Copyright 2024 Team Fireworks

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the “Software”), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so,subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.

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

return prvd.new("ohmyprvd@ComponentsProvider", ComponentsProvider)
