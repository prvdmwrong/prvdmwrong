local threads = require("core/utils/threads")

export type Lifecycle<Args...> = {
  callbacks: { (Args...) -> () },
  method: string,
  register: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
  fire: (self: Lifecycle<Args...>, Args...) -> (),
  unregister: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
  unregisterAll: (self: Lifecycle<Args...>) -> (),
  onRegistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
  onUnregistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
}

local ALLOW_MULTIPLE_LISTENERS = false
local Lifecycles = {}

local function findAndRemove<T>(from: { T }, toRemove: T)
  local oldIndex = table.find(from, toRemove)
  if oldIndex then
    table.remove(from, toRemove)
  end
end

function Lifecycles.Lifecycle<Args...>(
  method: string,
  onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
): Lifecycle<Args...>
  local self = {} :: Lifecycle<Args...>
  self.callbacks = {}
  self.fire = onFire
  self.method = method

  local onRegistered: { (Args...) -> () } = {}
  local onUnregistered: { (Args...) -> () } = {}

  function self:register(callback)
    if not ALLOW_MULTIPLE_LISTENERS then
      findAndRemove(self.callbacks, callback)
    end
    table.insert(self.callbacks, callback)
    threads.spawnCallbacks(onRegistered, callback)
  end

  function self:unregister(callback)
    local index = table.find(self.callbacks, callback)
    if index then
      table.remove(self.callbacks, index)
      threads.spawnCallbacks(onUnregistered, callback)
    end
  end

  function self:unregisterAll()
    for _, callback in self.callbacks do
      threads.spawnCallbacks(onUnregistered, callback)
    end
    table.clear(self.callbacks)
  end

  function self:onRegistered(listener)
    if not ALLOW_MULTIPLE_LISTENERS then
      findAndRemove(onRegistered, listener)
    end
    table.insert(onRegistered, listener)
    return function()
      findAndRemove(onRegistered, listener)
    end
  end

  function self:onUnregistered(listener)
    if not ALLOW_MULTIPLE_LISTENERS then
      findAndRemove(onUnregistered, listener)
    end
    table.insert(onUnregistered, listener)
    return function()
      findAndRemove(onUnregistered, listener)
    end
  end

  table.freeze(self)
  return self
end

function Lifecycles.fireConcurrent<Args...>(lifecycle: Lifecycle<Args...>, ...: Args...)
  threads.spawnCallbacks(lifecycle.callbacks, ...)
end

function Lifecycles.fireSequential<Args...>(lifecycle: Lifecycle<Args...>, ...: Args...)
  for _, callback in ipairs(lifecycle.callbacks) do
    callback(...)
  end
end

Lifecycles.providerInit = Lifecycles.Lifecycle("onInit", Lifecycles.fireSequential)
Lifecycles.providerStart = Lifecycles.Lifecycle("onStart", Lifecycles.fireConcurrent)
Lifecycles.providerStop = Lifecycles.Lifecycle("onStop", Lifecycles.fireConcurrent)

return Lifecycles
