local types = require("@compile/types")

return types.PackageConfig({
	name = "prvdmwrong",
	description = "Entry point to Prvd 'M Wrong",

	types = {
		["Lifecycle<Args... = ...unknown>"] = "Lifecycle<Args...>",
		["Provider<Self, Dependencies = nil>"] = "providers.Provider<Self, Dependencies>",
		Root = true,
		StartedRoot = true,
	},

	dependencies = types.PackageDependencies({
		lifecycles = true,
		providers = true,
		roots = true,
	}),
})
