--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

return {
	package = {
		name = (nil :: any) :: string,
		description = (nil :: any) :: string,
		version = (nil :: any) :: string,
		dependencies = (nil :: any) :: { [string]: string },
		license = "Apache-2.0 OR MIT",
		authors = { "znotfireman <znotfireman+hello@gmail.com>" },
		realm = "shared",
		repository = "https://github.com/prvdmwrong/prvdmwrong",
		registry = "https://github.com/UpliftGames/wally-index",
		include = { "./lib", "./default.project.json" },
		exclude = { "node_modules" },
	},
}
