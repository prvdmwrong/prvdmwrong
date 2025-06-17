local types = require("@compile/types")

return types.PackageConfig({
	name = "dependency",
	description = "Core functionality for Prvd 'M Wrong",

	types = table.freeze({
		["Dependency<Self>"] = true,
	}),

	dependencies = types.PackageDependencies({
		lifecycles = true,
	}),
})
