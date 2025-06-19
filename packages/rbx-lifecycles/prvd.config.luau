local configure = require("@lune-lib/configure")

return configure.package({
	name = "rbx-lifecycles",
	description = "Core functionality for Prvd 'M Wrong",

	pesdeTargets = {
		roblox = true,
	},

	dependencies = configure.dependencies({
		prvdmwrong = true,
	}),
})
