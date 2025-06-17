local types = require("@compile/types")

return types.PackageConfig({
	name = "rbx-lifecycles",
	description = "Extra lifecycles for Prvd 'M Wrong",

	dependencies = types.PackageDependencies({
		core = true,
		lifecycles = true,
	}),
})
