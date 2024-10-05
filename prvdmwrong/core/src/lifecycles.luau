local assertion = require("core/utils/assertion")
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
  destroy: (self: Lifecycle<Args...>) -> (),
}

local DISALLOW_MULTIPLE_LISTENERS = false

local lifecycleRegistered = {}
local lifecycleUnregistered = {}
local lifecycleDestroying = {}

local Lifecycles = {}
Lifecycles.methodLifecycles = {} :: { [string]: { Lifecycle<...unknown> } }

local function findAndRemove<T>(from: { T }, toRemove: T)
  local oldIndex = table.find(from, toRemove)
  if oldIndex then
    table.remove(from, toRemove)
  end
end

function Lifecycles.lifecycle<Args...>(
  method: string,
  onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
): Lifecycle<Args...>
  local self = {} :: Lifecycle<Args...>
  self.callbacks = {}
  self.fire = onFire
  self.method = method

  local selfRegistered: { (Args...) -> () } = {}
  local selfUnregistered: { (Args...) -> () } = {}
  local isDestroyed = false

  function self:register(callback)
    assertion(not isDestroyed, "cannot register listeners after a lifecycle is destroyed")
    if DISALLOW_MULTIPLE_LISTENERS then
      findAndRemove(self.callbacks, callback)
    end
    table.insert(self.callbacks, callback)
    threads.spawnCallbacks(selfRegistered, callback)
  end

  function self:unregister(callback)
    assertion(not isDestroyed, "cannot unregister listeners after a lifecycle is destroyed")
    local index = table.find(self.callbacks, callback)
    if index then
      table.remove(self.callbacks, index)
      threads.spawnCallbacks(selfUnregistered, callback)
    end
  end

  function self:unregisterAll()
    assertion(not isDestroyed, "cannot unregister all listeners after a lifecycle is destroyed")
    for _, callback in self.callbacks do
      threads.spawnCallbacks(selfUnregistered, callback)
    end
    table.clear(self.callbacks)
  end

  function self:onRegistered(listener)
    assertion(not isDestroyed, "cannot hook onto a lifecycle is destroyed")
    if DISALLOW_MULTIPLE_LISTENERS then
      findAndRemove(selfRegistered, listener)
    end
    table.insert(selfRegistered, listener)
    return function()
      findAndRemove(selfRegistered, listener)
    end
  end

  function self:onUnregistered(listener)
    assertion(not isDestroyed, "cannot hook onto a lifecycle is destroyed")
    if DISALLOW_MULTIPLE_LISTENERS then
      findAndRemove(selfUnregistered, listener)
    end
    table.insert(selfUnregistered, listener)
    return function()
      findAndRemove(selfUnregistered, listener)
    end
  end

  function self:destroy()
    assertion(not isDestroyed, "cannot destroy a lifecycle twice")
    findAndRemove(Lifecycles.methodLifecycles[method], self)
    threads.spawnCallbacks(lifecycleDestroying, self)
    table.clear(self.callbacks)
    isDestroyed = true
  end

  local methodLifecycles = Lifecycles.methodLifecycles[method]
  if not methodLifecycles then
    local newMethodLifecycles = {}
    Lifecycles.methodLifecycles[method] = newMethodLifecycles
    methodLifecycles = newMethodLifecycles
  end

  table.insert(methodLifecycles, self)
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

function Lifecycles.onRegistered<Args...>(listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()): () -> ()
  if DISALLOW_MULTIPLE_LISTENERS then
    findAndRemove(lifecycleRegistered, listener)
  end

  table.insert(lifecycleRegistered, listener)

  return function()
    findAndRemove(lifecycleRegistered, listener)
  end
end

function Lifecycles.onUnregistered<Args...>(listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()): () -> ()
  if DISALLOW_MULTIPLE_LISTENERS then
    findAndRemove(lifecycleUnregistered, listener)
  end

  table.insert(lifecycleUnregistered, listener)

  return function()
    findAndRemove(lifecycleUnregistered, listener)
  end
end

function Lifecycles.onLifecycleDestroying<Args...>(listener: (destroyedLifecycle: Lifecycle<Args...>) -> ()): () -> ()
  if DISALLOW_MULTIPLE_LISTENERS then
    findAndRemove(lifecycleDestroying, listener)
  end

  table.insert(lifecycleDestroying, listener)

  return function()
    findAndRemove(lifecycleDestroying, listener)
  end
end

Lifecycles.providerInit = Lifecycles.lifecycle("onInit", Lifecycles.fireSequential)
Lifecycles.providerStart = Lifecycles.lifecycle("onStart", Lifecycles.fireConcurrent)
Lifecycles.providerStop = Lifecycles.lifecycle("onStop", Lifecycles.fireConcurrent)

return Lifecycles
