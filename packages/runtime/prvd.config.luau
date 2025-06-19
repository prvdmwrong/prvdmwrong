local configure = require("@lune-lib/configure")

return configure.package({
	name = "runtime",
	description = "Runtime agnostic libraries for Prvd 'M Wrong",

	types = {
		RuntimeName = true,
	},
})
