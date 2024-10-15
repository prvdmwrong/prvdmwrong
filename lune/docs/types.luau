local t = require("../tiny")

local types = {}

export type Config = {
	config: {
		name: string,
		module: string,
		description: string,
		dependencies: { string },
	},
	docs: {
		classes: { string },
		overview: string,
	},
}

types.Config = t.interface {
	config = t.interface {
		name = t.string,
		module = t.string,
		description = t.string,
		dependencies = t.array(t.string),
	},
	docs = t.interface {
		classes = t.array(t.string),
		overview = t.string,
	},
}

return types
