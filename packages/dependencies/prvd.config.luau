local configure = require("@configure")

return configure.package({
	name = "dependencies",
	description = "Core functionality for Prvd 'M Wrong",

	types = table.freeze({
		["Dependency<Self, Dependencies = nil>"] = "Dependency<Self, Dependencies>",
	}),

	dependencies = configure.dependencies({
		lifecycles = true,
		logger = true,
	}),
})
