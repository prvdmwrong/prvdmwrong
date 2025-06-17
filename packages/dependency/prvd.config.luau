local types = require("@compile/types")

return types.PackageConfig({
	name = "dependency",
	description = "Core functionality for Prvd 'M Wrong",

	dependencies = types.PackageDependencies({
		logger = true,
		lifecycles = true,
		runtime = true,
	}),
})
