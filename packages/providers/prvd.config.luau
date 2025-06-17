local types = require("@compile/types")

return types.PackageConfig({
	name = "providers",
	description = "Core functionality for Prvd 'M Wrong",

	dependencies = types.PackageDependencies({
		dependency = true,
		logger = true,
		lifecycles = true,
		runtime = true,
	}),
})
