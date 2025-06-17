local types = require("@compile/types")

return types.PackageConfig({
	name = "rbx-lifecycles",
	description = "Core functionality for Prvd 'M Wrong",

	pesdeTargets = {
		roblox = true,
	},

	dependencies = types.PackageDependencies({
		logger = true,
		providers = true,
		lifecycles = true,
		runtime = true,
	}),
})
