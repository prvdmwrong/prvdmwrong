local types = require("@compile/types")

return types.PackageConfig({
	name = "logger",
	description = "Logging for Prvd 'M Wrong",

	dependencies = {
		runtime = true,
	},

	types = {
		["Logger<Templates>"] = true,
		Log = true,
		Error = true,
	},
})
