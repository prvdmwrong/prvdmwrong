local any: any = nil

return {
	package = {
		name = any :: string,
		description = any :: string,
		version = any :: string,
		dependencies = {} :: { [string]: string },
		license = any :: string,
		authors = any :: { string },

		realm = "shared",
		repository = any :: string,
		registry = "https://github.com/UpliftGames/wally-index",

		include = {
			"./src",
			"./default.project.json",
		},

		exclude = {
			"node_modules",
		},
	},
}
