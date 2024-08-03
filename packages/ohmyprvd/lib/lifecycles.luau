--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT

local Package = script.Parent
local Types = require(Package.types)

type Lifecycle<Interface = { [any]: any }> = Types.Lifecycle
type Object = { [unknown]: unknown }

local lifecycles = {}
lifecycles.methodRegistered = {} :: { [string]: { [{}]: (Object) -> () } }
lifecycles.methodUnregistered = {} :: { [string]: { [{}]: (Object) -> () } }
lifecycles.lifecycleMethods = {} :: { [string]: { [Lifecycle]: true } }

--[[
  Registers lifecycle methods for an object.
  @internal
]]
function lifecycles.registerMethod(object: Object, method: string)
  local methodRegistered = lifecycles.methodRegistered[method]
  if not methodRegistered then
    return
  end

  for _, handler in pairs(methodRegistered) do
    handler(object)
  end
end

--[[
  Unregister lifecycle methods from an object.
  @internal
]]
function lifecycles.unregisterMethod(object: Object, method: string)
  if not object or not object[method] then
    return
  end

  local methodUnregistered = lifecycles.methodUnregistered[method]
  if not methodUnregistered then
    return
  end

  for _, handler in pairs(methodUnregistered) do
    handler(object)
  end
end

--[[
  Registers all lifecycle methods on an object.
  @internal
]]
function lifecycles.registerAll(object: Object)
  for method, lifecycles in pairs(lifecycles.lifecycleMethods) do
    if typeof(object[method]) ~= "function" then
      continue
    end
    for lifecycle in pairs(lifecycles) do
      lifecycle:register(object)
    end
  end
end

--[[
  Constructs and returns a lifecycle method.
]]
function lifecycles.Lifecycle(method: string, fire: (self: Lifecycle, ...unknown) -> ()): Lifecycle
  local self = {} :: Lifecycle
  self.listeners = {}
  self.fire = fire

  function self:register(object)
    assert(typeof(object[method] == "function"), "invalid lifecycle listener")
    assert(not table.find(self.listeners, object), "already registered this object")
    lifecycles.registerMethod(object, method)
    table.insert(self.listeners, object)
  end

  function self:unregister(object)
    local index = table.find(self.listeners, object)
    if table.find(self.listeners, object) then
      table.remove(self.listeners, index)
      lifecycles.unregisterMethod(object, method)
    end
  end

  local lifecycleMethods = lifecycles.lifecycleMethods[method]
  if not lifecycleMethods then
    local methods = {}
    lifecycles.lifecycleMethods[method] = methods
    lifecycleMethods = methods
  end
  lifecycleMethods[self] = true

  table.freeze(self)
  return self
end

--[[
  Called when an object registers a method. Handlers are expected to be
  infallible and non-yielding. The handler receives the implementing object.
]]
function lifecycles.onMethodRegistered(method: string, handler: (Object) -> ())
  local methodRegistered = lifecycles.methodRegistered[method]
  if not methodRegistered then
    local ref = {}
    lifecycles.methodRegistered[method] = ref
    methodRegistered = ref
  end
  local identifier = table.freeze {}
  methodRegistered[identifier] = handler
end

--[[
  Called when an object unregister a method. Handlers are expected to be
  infallible and non-yielding. The handler receives the implementing object.
]]
function lifecycles.onMethodUnregistered(method: string, handler: (Object) -> ())
  local methodUnregistered = lifecycles.methodUnregistered[method]
  if not methodUnregistered then
    local ref = {}
    lifecycles.methodUnregistered[method] = ref
    methodUnregistered = ref
  end
  local identifier = table.freeze {}
  methodUnregistered[identifier] = handler
end

table.freeze(lifecycles)
return lifecycles
