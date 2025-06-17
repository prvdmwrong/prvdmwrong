local types = require("@compile/types")

return types.PackageConfig({
	name = "roots",
	description = "Core functionality for Prvd 'M Wrong",

	types = {
		Root = true,
		StartedRoot = true,
	},

	dependencies = types.PackageDependencies({
		logger = true,
		lifecycles = true,
		runtime = true,
		providers = true,
	}),
})
