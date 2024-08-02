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

local types = require(script.Parent.types)

type UnknownProvider = types.UnknownProvider

local methodHandlers:   { [string]: { [{}]: (UnknownProvider) -> () } } = {}
local providerHandlers: { [{}]: (UnknownProvider) -> () } = {}
local useHandlers:      { [{}]: (UnknownProvider) -> () } = {}
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
