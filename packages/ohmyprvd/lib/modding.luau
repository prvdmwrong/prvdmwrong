--!strict
--!nolint LocalShadow
-- Oh My Prvd code licensed under MIT

local package = script.Parent
local types = require(package.types)

type UnknownProvider = types.UnknownProvider

local methodHandlers: { [string]: { [{}]: (UnknownProvider) -> () } } = {}
local providerHandlers: { [{}]: (UnknownProvider) -> () } = {}
local useHandlers: { [{}]: (UnknownProvider) -> () } = {}
local mods = {}

--[[
  Implements all lifecycle methods for a provider. This function is not useful
  outside of Oh My Prvd, it is intended for library authors who need a way to
  interface with lifecycle methods, e.g. components.
]]
function mods.implementAllMethods(provider: UnknownProvider)
  for method, handlers in pairs(methodHandlers) do
    local method = (provider :: {})[method]
    if method == nil then
      continue
    end
    for _, handler in pairs(handlers) do
      handler(provider)
    end
  end
end

function mods.doMethodImplemented(method: string, provider: UnknownProvider)
  if not methodHandlers[method] then
    return
  end
  for _, handler in pairs(methodHandlers[method]) do
    handler(provider)
  end
end

function mods.doProviderConstructed(provider: UnknownProvider)
  if next(providerHandlers) == nil then
    return
  end
  for _, handler in pairs(providerHandlers) do
    handler(provider)
  end
end

function mods.doProviderUsed(provider: UnknownProvider)
  if next(useHandlers) == nil then
    return
  end
  for _, handler in pairs(useHandlers) do
    handler(provider)
  end
end

--[[
  Called when a provider implements a method. Handlers are expected to be
  infallible and non-yielding. The handler receives the constructed provider.
  Commonly used to implement custom lifecycles by adding providers to a
  "watchlist" which will have its methods fired.
]]
function mods.onMethodImplemented(method: string, handler: (UnknownProvider) -> ())
  if not methodHandlers[method] then
    methodHandlers[method] = {}
  end
  local identifier = table.freeze {}
  methodHandlers[method][identifier] = handler
end

--[[
  Called just before Oh My Prvd returns a newly constructed provider. Handlers
  are expected to be infallible and non-yielding. The handler receives the
  constructed provider.
]]
function mods.onProviderConstructed(handler: (UnknownProvider) -> ())
  local identifier = table.freeze {}
  providerHandlers[identifier] = handler
end

--[[
  Called just before Oh My Prvd returns a used Provider. Handlers are expected
  to be infallible and non-yielding. The handler receives the used provider.
]]
function mods.onProviderUsed(handler: (UnknownProvider) -> ())
  local identifier = table.freeze {}
  useHandlers[identifier] = handler
end

table.freeze(mods)
return mods
