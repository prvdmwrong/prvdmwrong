local create = require("@self/create")
local providerClasses = require("@self/provider-classes")
local types = require("@self/types")

export type Provider<Self> = types.Provider<Self>

local providers = table.freeze({
	create = create,
	_ = table.freeze({
		providerClasses = providerClasses,
	}),
})

return providers
