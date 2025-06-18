local configure = require("@configure")

return configure.package({
	name = "prvdmwrong",
	description = "Entry point to Prvd 'M Wrong",

	types = {
		["Lifecycle<Args... = ...unknown>"] = "Lifecycle<Args...>",
		["Provider<Self, Dependencies = nil>"] = "providers.Provider<Self, Dependencies>",
		Root = true,
		StartedRoot = true,
	},

	dependencies = configure.dependencies({
		lifecycles = true,
		providers = true,
		roots = true,
	}),
})
