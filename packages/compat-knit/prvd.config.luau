local configure = require("@lune-lib/configure")

return configure.package({
	name = "compat-knit",
	description = "Prvd 'M Wrong drop-in Knit replacement",

	dependencies = configure.dependencies({
		prvdmwrong = true,
	}),
})
