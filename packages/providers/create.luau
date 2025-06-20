local nameOf = require("./name-of")
local providerClasses = require("./provider-classes")
local types = require("./types")

local function createProvider<Self>(self: Self): types.Provider<Self>
	local provider: types.Provider<Self> = self :: any

	if provider.__index == nil then
		provider.__index = provider
	end

	if provider.__tostring == nil then
		provider.__tostring = nameOf
	end

	if provider.new == nil then
		function provider.new()
			local self: types.Provider<Self> = setmetatable({}, provider) :: any
			if provider.constructor then
				return provider.constructor(self) or self
			end
			return self
		end
	end

	providerClasses[provider] = true
	return provider
end

return createProvider
