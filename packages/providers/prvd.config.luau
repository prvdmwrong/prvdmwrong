local configure = require("@lune-lib/configure")

return configure.package({
	name = "providers",
	description = "Provider creation for Prvd 'M Wrong",

	types = {
		["Provider<Self, Dependencies = nil>"] = "Provider<Self, Dependencies>",
	},

	dependencies = configure.dependencies({
		dependencies = true,
		logger = true,
		lifecycles = true,
		runtime = true,
	}),
})
