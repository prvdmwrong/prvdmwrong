local types = require("@compile/types")

return types.PackageConfig({
	name = "prvdmwrong",
	description = "Entry point to Prvd 'M Wrong",

	dependencies = types.PackageDependencies({
		lifecycles = true,
		providers = true,
		roots = true,
	}),
})
