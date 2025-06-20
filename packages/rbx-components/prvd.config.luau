local configure = require("@lune-lib/configure")

return configure.package({
	name = "rbx-components",
	description = "Component functionality for Prvd 'M Wrong",

	dependencies = configure.dependencies({
		logger = true,
		roots = true,
		providers = true,
		dependencies = true,
	}),
})
