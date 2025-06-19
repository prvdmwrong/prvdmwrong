local configure = require("@lune-lib/configure")

return configure.package({
	name = "lifecycles",
	description = "Extra lifecycles for Prvd 'M Wrong",

	dependencies = configure.dependencies({
		logger = true,
		runtime = true,
	}),

	types = {
		["Lifecycle<Args... = ...unknown>"] = "Lifecycles<Args...>",
	},
})
