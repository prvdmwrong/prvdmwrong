local StringBuilder = require("../../utils/string-builder")
local fs = require("@lune/fs")
local path = require("../../utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local tabler = require("../../utils/tabler")
local types = require("../types")

local PATH_ZED_SETTINGS = path(process.cwd, ".zed", "settings.json")
local ZED_SETTINGS = {
	languages = {
		Luau = {
			formmatter = {
				external = {
					arguments = { "-" },
					command = "stylua",
				},
			},
		},
	},
	lsp = {
		["luau-lsp"] = {
			settings = {
				ext = {
					fflags = {
						enable_by_default = false,
						sync = true,
						override = {
							LuauTypeSolverRelease = "646",
							LuauSolverV2 = "True",
							LuauUserDefinedTypeFunctionsSyntax = "True",
							LuauUserDefinedTypeFunctions = "True",
						},
					},
				},
				prefer_worktree_binary = true,
				roblox = {
					enabled = true,
				},
				["luau-lsp"] = {
					require = {
						directoryAliases = {} :: { [string]: string },
						mode = "relativeToFile",
					},
				},
			},
		},
	},
}

local ZedGenerator = {} :: types.Generator
ZedGenerator.type = "Generator"
ZedGenerator.of = "Zed's setting.json"

function ZedGenerator:generate(packages: { types.PackageData })
	local newSettings = tabler.clone(ZED_SETTINGS)
	local directoryAliases = {}
	directoryAliases["@lune"] = "~/.lune/.typedefs/0.8.8/"
	directoryAliases["@lunescripts"] = "./lune"

	for _, package in packages do
		print("  Aliasing", package.relativePath, "as", package.name)
		directoryAliases["@" .. package.name] = path(package.relativePath, "src")
	end

	newSettings.lsp["luau-lsp"].settings["luau-lsp"].require.directoryAliases = directoryAliases

	fs.writeFile(
		PATH_ZED_SETTINGS,
		StringBuilder()
			:appendLn("// This file was @generated and should not be edited.")
			:appendLn("// Run `lune run regen` to generate fresh Zed settings.")
			:appendLn()
			:appendLn(serde.encode("json", newSettings, true))
			:build()
	)
end

return ZedGenerator
