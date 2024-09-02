--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

return {
	name = (nil :: any) :: string,
	description = (nil :: any) :: string,
	version = (nil :: any) :: string,
	dependencies = (nil :: any) :: { [string]: string },
	main = "lib/init.lua",
	author = "znotfireman <znotfireman+hello@gmail.com>",
	license = "Apache-2.0 OR MIT",
	types = "lib/index.d.ts",
	files = {
		"lib",
		"!**/*.tsbuildinfo",
	},
	publishConfig = {
		access = "public",
	},
	devDependencies = {
		["@rbxts/compiler-types"] = "2.3.0-types.1",
		["@rbxts/types"] = "^1.0.790",
		["roblox-ts"] = "^2.3.0",
		typescript = "^5.5.4",
	},
}
