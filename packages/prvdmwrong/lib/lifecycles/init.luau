--!strict
-- (c) Prvd 'M Wrong, dual-licensed under Apache 2.0 and MIT terms.

local Types = require("prvdmwrong/types")
local log = require("prvdmwrong/utils/log")

type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle
type Object = { [unknown]: unknown }

local Lifecycles = {}
Lifecycles.methodRegistered = {} :: { [string]: { [{}]: (Object) -> () } }
Lifecycles.methodUnregistered = {} :: { [string]: { [{}]: (Object) -> () } }
Lifecycles.lifecycleMethods = {} :: { [string]: { [Lifecycle]: true } }

--[=[
  Implements lifecycle methods for an object.
  @internal
]=]
function Lifecycles.implementMethod(method: string, object: Object)
  local methodRegistered = Lifecycles.methodRegistered[method]
  if not methodRegistered then
    return
  end

  for _, handler in pairs(methodRegistered) do
    handler(object)
  end
end

--[=[
  Unimplements lifecycle methods from an object.
  @internal
]=]
function Lifecycles.unimplementMethod(method: string, object: Object)
  if not object or not object[method] then
    return
  end

  local methodUnregistered = Lifecycles.methodUnregistered[method]
  if not methodUnregistered then
    return
  end

  for _, handler in pairs(methodUnregistered) do
    handler(object)
  end
end

--[=[
  Implements all lifecycle methods on an object.
  @internal
]=]
function Lifecycles.implementAll(object: Object)
  for method, lifecycles in pairs(Lifecycles.lifecycleMethods) do
    if typeof(object[method]) ~= "function" then
      continue
    end
    for lifecycle in pairs(lifecycles) do
      lifecycle:register(object)
    end
  end
end

--[=[
  Constructs and returns a lifecycle method.
]=]
function Lifecycles.Lifecycle(method: string, fire: (self: Lifecycle, ...unknown) -> ()): Lifecycle
  log.expect(typeof(method) == "string", "cannotRegisterLifecycle", "expected a method to register with")
  log.expect(typeof(fire) == "function", "cannotRegisterLifecycle", "expected a function for firing")

  local self = {} :: Lifecycle
  self.listeners = {}
  self.method = method
  self.fire = fire

  function self:register(object)
    log.expect(typeof(object[method]) == "function", "cannotRegisterLifecycle", `{method} must be a method`)
    log.expect(not table.find(self.listeners, object), "cannotRegisterLifecycle", `already registered this lifecycle`)

    Lifecycles.implementMethod(method, object)
    table.insert(self.listeners, object)
  end

  function self:unregister(object)
    local index = table.find(self.listeners, object)
    if table.find(self.listeners, object) then
      table.remove(self.listeners, index)
      Lifecycles.unimplementMethod(method, object)
    end
  end

  local lifecycleMethods = Lifecycles.lifecycleMethods[method]
  if not lifecycleMethods then
    local methods = {}
    Lifecycles.lifecycleMethods[method] = methods
    lifecycleMethods = methods
  end
  lifecycleMethods[self] = true

  table.freeze(self)
  return self
end

--[=[
  Called when an object registers a method. Handlers are expected to be
  infallible and non-yielding. The handler receives the implementing object.
]=]
function Lifecycles.onLifecycleRegistered(method: string, handler: (Object) -> ())
  local methodRegistered = Lifecycles.methodRegistered[method]
  if not methodRegistered then
    local ref = {}
    Lifecycles.methodRegistered[method] = ref
    methodRegistered = ref
  end
  local identifier = table.freeze {}
  methodRegistered[identifier] = handler
end

--[=[
  Called when an object unregister a method. Handlers are expected to be
  infallible and non-yielding. The handler receives the implementing object.
]=]
function Lifecycles.onLifecycleUnregistered(method: string, handler: (Object) -> ())
  local methodUnregistered = Lifecycles.methodUnregistered[method]
  if not methodUnregistered then
    local ref = {}
    Lifecycles.methodUnregistered[method] = ref
    methodUnregistered = ref
  end
  local identifier = table.freeze {}
  methodUnregistered[identifier] = handler
end

--[=[
  A handler for lifecycle methods that spawns all listeners concurrently.
]=]
function Lifecycles.fireConcurrent(self: Lifecycle, ...: unknown)
  for _, listener in ipairs(self.listeners) do
    task.spawn(listener[self.method], listener, ...)
  end
end

--[=[
  A handler for lifecycle methods that runs all listeners sequentially.
]=]
function Lifecycles.fireSequential(self: Lifecycle, ...: unknown)
  for _, listener in ipairs(self.listeners) do
    listener[self.method](listener, ...)
  end
end

--[=[
  @deprecated use either `onLifecycleRegistered` or `Lifecycle` instead
]=]
function Lifecycles.onMethodImplemented(method: string, handler: (Object) -> ())
  log.warn("onMethodImplementedWasDeprecated", method)
  Lifecycles.onLifecycleRegistered(method, handler)
end

table.freeze(Lifecycles)
return Lifecycles
