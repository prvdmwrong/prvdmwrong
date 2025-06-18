local configure = require("@configure")

return configure.package({
	name = "roots",
	description = "Core functionality for Prvd 'M Wrong",

	types = {
		Root = true,
		StartedRoot = true,
	},

	dependencies = configure.dependencies({
		logger = true,
		lifecycles = true,
		runtime = true,
		providers = true,
	}),
})
