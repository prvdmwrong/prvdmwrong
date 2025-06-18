local types = require("@compile/types")

return types.PackageConfig({
	name = "providers",
	description = "Core functionality for Prvd 'M Wrong",

	types = {
		["Provider<Self, Dependencies = nil>"] = "Provider<Self, Dependencies>",
	},

	dependencies = types.PackageDependencies({
		dependencies = true,
		logger = true,
		lifecycles = true,
		runtime = true,
	}),
})
