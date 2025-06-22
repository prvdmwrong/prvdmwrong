local configure = require("@lune-lib/configure")

return configure.package({
	name = "compat-axiom",
	description = "Prvd 'M Wrong v0.2 drop-in Axiom/Lumin Framework v11 replacement",

	pesdeTargets = {
		roblox = true,
	},

	dependencies = configure.dependencies({
		prvdmwrong = true,
		runtime = true,
		logger = true,
	}),
})
