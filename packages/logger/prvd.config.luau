local configure = require("@configure")

return configure.package({
	name = "logger",
	description = "Logging for Prvd 'M Wrong",

	dependencies = configure.dependencies({
		runtime = true,
	}),

	types = {
		["Logger<Templates>"] = true,
		Log = true,
		Error = true,
	},
})
