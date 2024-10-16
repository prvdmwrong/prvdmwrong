local Log = require("@scripts/_utils/log")
local fs = require("@lune/fs")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local regenTypes = require("@scripts/regen/types")
local serde = require("@lune/serde")
local tabler = require("@scripts/_utils/tabler")
local types = require("@scripts/_types")

type ConvertRequireRule = {
	rule: "convert_require",
	current: {
		name: "path",
		sources: { [string]: string },
	},
	target: {
		indexing_style: "property",
		name: "roblox",
		rojo_sourcemap: "./sourcemap.json",
	},
}

local DARKLUA_PATH = path(process.cwd, "darklua.json")
local BASE_DARKLUA_CONFIG = {
	generator = "retain_lines",
	rules = {
		{
			rule = "convert_require",
			current = {
				name = "path",
				sources = {},
			},
			target = {
				indexing_style = "property",
				name = "roblox",
				rojo_sourcemap = "./sourcemap.json",
			},
		},
		{
			identifier = "PRVDMWRONG_BUILD",
			rule = "inject_global_value",
			value = false,
		},
		{
			env = "PRVDMWRONG_VERSION",
			identifier = "PRVDMWRONG_VERSION",
			rule = "inject_global_value",
		},
		"compute_expression",
		"remove_unused_if_branch",
		"remove_unused_while",
		"filter_after_early_return",
		"remove_nil_declaration",
		"remove_empty_do",
	},
}

local DarkluaRegenerator = {} :: regenTypes.Generator
function DarkluaRegenerator:generate(packages: { types.Package }, log: Log.Log)
	log.print("Generating Darklua configuration")
	log.indent()

	local sources = {}
	for _, package in packages do
		log.print("Aliasing", package.relativePath)
		sources["@" .. package.packageName] = path(package.relativePath, "src")
	end

	log.unIndent()
	log.print("Adding sources to Darklua configuration")
	local newConfig = tabler.deepCopy(BASE_DARKLUA_CONFIG)
	for _, rule in newConfig.rules do
		if typeof(rule) ~= "table" or rule.rule ~= "convert_require" then
			continue
		end
		local convertRequire = rule :: ConvertRequireRule
		convertRequire.current.sources = sources
	end

	log.print("Writing to darklua.json")
	fs.writeFile(DARKLUA_PATH, serde.encode("json", newConfig, true))
end

return DarkluaRegenerator
