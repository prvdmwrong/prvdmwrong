--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

return {
	main = "lib/init.luau",
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
