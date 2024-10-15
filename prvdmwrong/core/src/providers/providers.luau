local types = require("@core/types")

type ConstructedKey = types.ConstructedKey
type Provider<Self> = types.Provider<Self>
type LuauSolverIssue = any

-- Required so TypeScript class decorators can properly register providers
local CONSTRUCTED_KEY: ConstructedKey = newproxy();
(getmetatable(CONSTRUCTED_KEY :: any) :: any).__tostring = function()
	return "<Prvd 'M Wrong> CONSTRUCTED_KEY"
end

local constructedProviders = {}
local providerConstructed = {}

local providers = {}
providers.constructedKey = CONSTRUCTED_KEY
providers.constructedProviders = constructedProviders

--[=[
    @within Prvd
    Construct and returns a new provider. Providers *provide* specific functionality in a game.

    @param provider Self -- The provider and associated properties itself.
    @return Provider<Self> -- A newly constructed provider.
]=]
function providers.prvd<Self>(provider: Self, name: string?): Provider<Self>
	local newProvider: Provider<Self> = provider
	newProvider.name = newProvider.name or name
	newProvider[CONSTRUCTED_KEY] = newProvider
	constructedProviders[newProvider] = true

	for _, onProviderConstructed in providerConstructed do
		onProviderConstructed(newProvider)
	end

	return newProvider
end

function providers.Provider() end

function providers.onProviderConstructed(listener: (provider: Provider<unknown>) -> ()): () -> ()
	local identifier = table.freeze({})
	providerConstructed[identifier] = listener

	return function()
		providerConstructed[identifier] = nil :: LuauSolverIssue
	end
end

return providers
