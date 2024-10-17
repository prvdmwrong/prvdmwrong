local Log = require("@scripts/_utils/log")
local StringBuilder = require("@scripts/_builders/string-builder")
local fs = require("@lune/fs")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local regenTypes = require("@scripts/regen/types")
local serde = require("@lune/serde")
local tabler = require("@scripts/_utils/tabler")
local types = require("@scripts/_types")

local ZED_SETTINGS = path(process.cwd, ".zed", "settings.json")
local BASE_DIRECTORY_ALIASES: { [string]: string } = {
	["@lune"] = "~/.lune/.typedefs/0.8.8/",
	["@scripts"] = "./lune",
}

local BASE_ZED_SETTINGS = {
	formatter = {
		external = {
			command = "npx prettier",
			arguments = { "--stdin-filepath", "{buffer_path}" },
		},
	},
	languages = {
		Luau = {
			formmatter = {
				external = {
					command = "stylua",
					arguments = { "-" },
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
						directoryAliases = {},
						mode = "relativeToFile",
					},
				},
			},
		},
	},
}

local ZedRegenerator = {} :: regenTypes.Generator
function ZedRegenerator:generate(packages: { types.Package }, log: Log.Log)
	local newSettings = tabler.deepCopy(BASE_ZED_SETTINGS)
	local directoryAliases = table.clone(BASE_DIRECTORY_ALIASES)

	log.print("Writing directory aliases for Zed configuration")
	log.indent()
	for _, package in packages do
		log.print("Aliasing", package.relativePath, "as", package.packageName)
		directoryAliases["@" .. package.packageName] = path(package.relativePath, "src")
	end

	log.unIndent()
	log.print("Writing to local .zed/settings.json")

	newSettings.lsp["luau-lsp"].settings["luau-lsp"].require.directoryAliases = directoryAliases
	fs.writeFile(
		ZED_SETTINGS,
		StringBuilder()
			:appendLn("// This file was @generated and should not be edited.")
			:appendLn("// Run `lune run regen` to generate fresh Zed settings.")
			:appendLn()
			:appendLn(serde.encode("json", newSettings, true))
			:build()
	)
end

return ZedRegenerator
