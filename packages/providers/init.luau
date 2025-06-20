local create = require("@self/create")
local nameOf = require("@self/name-of")
local providerClasses = require("@self/provider-classes")
local types = require("@self/types")

export type Provider<Self, Dependencies = nil> = types.Provider<Self, Dependencies>

local providers = table.freeze({
	create = create,
	nameOf = nameOf,
	_ = table.freeze({
		providerClasses = providerClasses,
	}),
})

return providers
