--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local Types = require("prvdmwrong-core/types")

type Provider<T> = Types.Provider<T>
type Object = Types.Object

local Modding = {}
Modding.constructedHandlers = {} :: { [{}]: (Provider<unknown>) -> () }
Modding.usedHandlers = {} :: { [{}]: (Provider<unknown>) -> () }
Modding.providers = {} :: { [Types.Provider<unknown>]: true }

function Modding.doProviderConstructed(provider: Provider<unknown>)
	if next(Modding.constructedHandlers) == nil then
		return
	end
	for _, handler in pairs(Modding.constructedHandlers) do
		handler(provider)
	end
end

function Modding.doProviderUsed(provider: Provider<unknown>)
	if next(Modding.usedHandlers) == nil then
		return
	end
	for _, handler in pairs(Modding.usedHandlers) do
		handler(provider)
	end
end

--[=[
  Adds the given object as a dependency that Prvd 'M Wrong will instantiate
  during startup.
]=]
function Modding.registerDependency(dependency: Types.Object)
	Modding.providers[dependency :: any] = true
end

--[=[
  Called just before Prvd 'M Wrong returns a newly constructed provider. Handlers
  are expected to be infallible and non-yielding. The handler receives the
  constructed provider.
]=]
function Modding.onProviderConstructed(handler: (Provider<unknown>) -> ())
	local identifier = table.freeze {}
	Modding.constructedHandlers[identifier] = handler
end

--[=[
  Called just before Prvd 'M Wrong returns a used Provider. Handlers are expected
  to be infallible and non-yielding. The handler receives the used provider.
]=]
function Modding.onProviderUsed(handler: (Provider<unknown>) -> ())
	local identifier = table.freeze {}
	Modding.constructedHandlers[identifier] = handler
end

table.freeze(Modding)
return Modding
