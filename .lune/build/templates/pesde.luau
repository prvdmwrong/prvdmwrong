--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

return {
	name = (nil :: any) :: string,
	description = (nil :: any) :: string,
	version = (nil :: any) :: string,
	license = "MIT",
	authors = { "znotfireman <znotfireman+hello@gmail.com>" },
	realm = "shared",
	repository = "https://github.com/prvdmwrong/prvdmwrong",
	indices = {
		default = "https://github.com/daimond113/pesde-index",
	},
	exports = {
		lib = "./lib/init.luau",
	},
	dependencies = {},
}
