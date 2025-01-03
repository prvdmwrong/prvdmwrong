local t = require("@scripts/_vendor/tiny")

local types = {}

export type Config = {
	name: string,
	description: string,
	dependencies: { string },

	docs: {
		classes: { string },
		overview: string,
	},
}

types.Config = t.interface {
	name = t.string,
	description = t.string,
	dependencies = t.array(t.string),
	docs = t.interface {
		classes = t.array(t.string),
		overview = t.string,
	},
}

export type RepoConfig = {
	publish: {
		authors: { string },
		repository: string,
		license: string,
		version: string,

		header: { string },

		scopes: {
			wally: string,
			pesde: string,
			npm: string,
		},
	},
	docs: {
		sort_order: { string },
	},
}

types.RepoConfig = t.interface {
	publish = t.interface {
		authors = t.array(t.string),
		repository = t.string,
		license = t.string,
		version = t.string,

		header = t.array(t.string),

		scopes = t.interface {
			wally = t.string,
			pesde = t.string,
			npm = t.string,
		},
	},
	docs = t.interface {
		sort_order = t.array(t.string),
	},
}

export type Package = {
	packageName: string,
	absolutePath: string,
	relativePath: string,
	config: Config,
}

export type Processor = {
	loadOrder: number?,
	process: (self: Processor, package: Package) -> (),
}

types.Processor = t.interface {
	loadOrder = t.optional(t.number),
	process = t.callback,
}

return types
