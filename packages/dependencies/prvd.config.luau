local types = require("@compile/types")

return types.PackageConfig({
	name = "dependencies",
	description = "Core functionality for Prvd 'M Wrong",

	types = table.freeze({
		["Dependency<Self, Dependencies = nil>"] = "Dependency<Self, Dependencies>",
	}),

	dependencies = types.PackageDependencies({
		lifecycles = true,
		logger = true,
	}),
})
