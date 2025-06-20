local configure = require("@lune-lib/configure")

return configure.package({
	name = "roots",
	description = "Roots implementation for Prvd 'M Wrong",

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
