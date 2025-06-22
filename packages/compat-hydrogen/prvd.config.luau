local configure = require("@lune-lib/configure")

return configure.package({
	name = "compat-hydrogen",
	description = "Prvd 'M Wrong v0.2 drop-in Hydrogen v0.2 replacement",

	pesdeTargets = {
		roblox = true,
	},

	dependencies = configure.dependencies({
		prvdmwrong = true,
		runtime = true,
		logger = true,
	}),
})
