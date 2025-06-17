local types = require("@compile/types")

return types.PackageConfig({
	name = "providers",
	description = "Core functionality for Prvd 'M Wrong",

	dependencies = types.PackageDependencies({
		dependencies = true,
		logger = true,
		lifecycles = true,
		runtime = true,
	}),
})
