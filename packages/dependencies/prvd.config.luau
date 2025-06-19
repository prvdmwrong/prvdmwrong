local configure = require("@lune-utils/configure")

return configure.package({
	name = "dependencies",
	description = "Core functionality for Prvd 'M Wrong",

	types = table.freeze({
		["Dependency<Self, Dependencies = nil, NewArgs... = ()>"] = "Dependency<Self, Dependencies, NewArgs...>",
	}),

	dependencies = configure.dependencies({
		lifecycles = true,
		logger = true,
		symbols = true,
	}),
})
