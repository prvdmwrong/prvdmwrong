local configure = require("@lune-lib/configure")

return configure.package({
	name = "rbx-lifecycles",
	description = "Lifecycles implementations for Roblox",

	pesdeTargets = {
		roblox = true,
	},

	dependencies = configure.dependencies({
		prvdmwrong = true,
	}),
})
