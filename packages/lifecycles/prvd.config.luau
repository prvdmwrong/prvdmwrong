local types = require("@compile/types")

return types.PackageConfig({
	name = "lifecycles",
	description = "Extra lifecycles for Prvd 'M Wrong",

	dependencies = types.PackageDependencies({
		logger = true,
		runtime = true,
	}),

	types = {
		["Lifecycle<Args... = ...unknown>"] = "Lifecycles<Args...>",
	},
})
