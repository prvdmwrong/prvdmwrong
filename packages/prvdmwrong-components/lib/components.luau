--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

-- FIXME: doing this for figuring out a possible API
--!nolint LocalUnused
--#selene: allow(unused_variable)

local CollectionService = game:GetService("CollectionService")

local prvd = require("prvdmwrong-components/prvd")
local types = require("prvdmwrong-components/types")
local Lifecycle = prvd.Lifecycle

-- stylua: ignore
export type Component<
  Methods,
  Instance = Instance,
  Attributes = { [any]: any }
> = types.Component<
  Methods,
  Instance,
  Attributes
>

export type ComponentStreamingMode = types.ComponentStreamingMode
export type OnComponentAdded = types.OnComponentAdded
export type OnComponentRemoved = types.OnComponentRemoved
type Provider<T> = prvd.Provider<T>
type Lifecycle<Interface = { [any]: any }> = prvd.Lifecycle<Interface>
type Map<K, V> = { [K]: V }
type Set<T> = { [T]: true }

local WEAK_KEYS_METATABLE = { __mode = "k" }
local COMPONENT_KEY = newproxy(true) :: { __COMPONENT_KEY__: never? }
getmetatable(COMPONENT_KEY :: any).__tostring = function()
  return "prvdmwrong-components.COMPONENT_KEY"
end
local DEFAULT_ANCESTOR_BLACKLIST: { Instance } = table.freeze {
  game:GetService("ReplicatedStorage"),
  game:GetService("ServerStorage"),
  game:GetService("StarterGui"),
  game:GetService("StarterPack"),
  game:GetService("StarterPlayer"),
}

local ComponentStreamingMode = table.freeze {
  Disabled = "ComponentStreamingMode.Disabled" :: "ComponentStreamingMode.Disabled",
  Watching = "ComponentStreamingMode.Watching" :: "ComponentStreamingMode.Watching",
  Contextual = "ComponentStreamingMode.Contextual" :: "ComponentStreamingMode.Contextual",
}

local components: Set<Component<unknown>> = {}
local componentAdded: Lifecycle<OnComponentAdded> = Lifecycle("onComponentAdded", prvd.fireConcurrent)
local componentRemoved: Lifecycle<OnComponentRemoved> = Lifecycle("onComponentRemoved", prvd.fireConcurrent)
local instanceToComponent: Map<Instance, Component<unknown>> = setmetatable({} :: any, WEAK_KEYS_METATABLE)

local Components = {}
type Self = typeof(Components)
Components.ComponentStreamingMode = ComponentStreamingMode
Components.loadOrder = 0

function Components.Component<T>(component: T): Component<T>
  error("not implemented")
end

function Components.onInit(self: Self)
  -- WIP
end

function Components.onStart(self: Self)
  for component in components do
    local ancestorBlacklist: { Instance } = component.ancestorBlacklist or DEFAULT_ANCESTOR_BLACKLIST
    local ancestorWhitelist = component.ancestorWhitelist
    local predicate = component.predicate

    if component.tag then
      local tag = component.tag

      local function instanceAdded(instance: Instance)
        if predicate and not predicate(instance) then
          return
        end

        if ancestorWhitelist then
          local whitelisted = false
          for _, ancestor in ipairs(ancestorWhitelist) do
            if instance:IsDescendantOf(ancestor) then
              whitelisted = true
              break
            end
          end
          if not whitelisted then
            return
          end
        end

        if ancestorBlacklist then
          local blacklisted = false
          for _, ancestor in ipairs(ancestorBlacklist) do
            if instance:IsDescendantOf(ancestor) then
              blacklisted = true
              break
            end
          end
          if blacklisted then
            return
          end
        end

        componentAdded:fire(component, instance)
        error("not implemented")
      end

      CollectionService:GetInstanceAddedSignal(tag):Connect(instanceAdded)
      CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance)
        Components:removeComponent(component, instance)
      end)

      for _, instance in ipairs(CollectionService:GetTagged(tag)) do
        instanceAdded(instance)
      end
    end
  end
  -- WIP
end

function Components.awaitComponent(self: Self, component: Component<unknown>, instance: Instance)
  error("not implemented")
end

function Components.hasComponent(self: Self, component: Component<unknown>, instance: Instance): boolean
  error("not implemented")
end

function Components.addComponent(self: Self, component: Component<unknown>, instance: Instance)
  error("not implemented")
end

function Components.removeComponent(self: Self, component: Component<unknown>, instance: Instance)
  error("not implemented")
end

return prvd(Components)
