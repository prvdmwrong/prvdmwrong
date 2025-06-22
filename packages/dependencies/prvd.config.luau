local configure = require("@lune-lib/configure")

return configure.package({
	name = "dependencies",
	description = "Dependency resolution logic for Prvd 'M Wrong",

	types = table.freeze({
		["Dependency<Self, Dependencies = nil, NewArgs... = ()>"] = "Dependency<Self, Dependencies, NewArgs...>",
	}),

	dependencies = configure.dependencies({
		lifecycles = true,
		logger = true,
	}),
})
