local prelude = require("../prelude")
local task = require("@lune/task")

local CWD_BUILD_DIRECTORY = prelude.cwdPath("build")
local BINS_DIRECTORY = prelude.path(CWD_BUILD_DIRECTORY, "bins")
local TARGETS_DIRECTORY = prelude.path(CWD_BUILD_DIRECTORY, "targets")
local TEMP_DIRECTORY = prelude.path(CWD_BUILD_DIRECTORY, "temp")

local DARKLUA_GENERATOR = "retain_lines"
local APPENDED_DARKLUA_RULES = {
	"compute_expression",
	"remove_unused_if_branch",
	"remove_unused_while",
	"filter_after_early_return",
	"remove_nil_declaration",
	"remove_empty_do",
}

local sources = {}
for _, name in prelude.allPackages() do
	print(name)
	local package = prelude.package(name)
	sources[`@{name}`] = package.relativePath
end

local darkluaRequires = {
	rule = "convert_require",
	current = {
		name = "path",
		sources = sources,
	},
	target = {
		indexing_style = "property",
		name = "roblox",
		rojo_sourcemap = "./sourcemap.json",
	},
}

local compiler = {}

function compiler.compile(configuration: {
	packages: { prelude.Package },
	mode: "development" | "release",
	featureFlags: { string },
})
	local progress = prelude
		.ProgressBar()
		-- Preperations
		:withStage("Preperations", "Creating build directory")
		:withStage("Preperations", "Creating build/bins directory")
		:withStage("Preperations", "Creating build/targets directory")
		:withStage("Preperations", "Creating build/temp directory")
		:withStage("Preperations", "Writing darklua configuration")
		:withStage("Preperations", "Compiling standalone")

	progress:start()

	if prelude.isDir(CWD_BUILD_DIRECTORY) :: never then
		prelude.removeDir(CWD_BUILD_DIRECTORY)
	end

	prelude.writeDir(CWD_BUILD_DIRECTORY)
	progress:nextStage()

	prelude.writeDir(BINS_DIRECTORY)
	progress:nextStage()

	prelude.writeDir(TARGETS_DIRECTORY)
	progress:nextStage()

	prelude.writeDir(TEMP_DIRECTORY)
	progress:nextStage()

	local rules: { string | { [any]: any } } = { darkluaRequires :: any }

	for _, feature in configuration.featureFlags do
		table.insert(rules, {
			rule = "inject_global_values",
			identifier = `PRVDMWRONG_FEATURE_{feature:upper()}`,
			value = true,
		})
	end

	for _, rule in APPENDED_DARKLUA_RULES do
		table.insert(rules, rule)
	end

	prelude.writeFileAs("json", prelude.path(TEMP_DIRECTORY, "darklua.json"), {
		generator = DARKLUA_GENERATOR,
		rules = rules,
	})

	progress:nextStage()

	progress:stop()
end

compiler.compile({ packages = {}, mode = "development", featureFlags = {} })

return compiler
--[[
    {
      "generator": "retain_lines",
      "rules": [
        {
          "current": {
            "name": "path",
            "sources": {
              "@components": "prvdmwrong/components/src",
              "@core": "prvdmwrong/core/src",
              "@knit-compat": "prvdmwrong/knit-compat/src",
              "@lifecycles": "prvdmwrong/lifecycles/src",
              "@lumin-compat": "prvdmwrong/lumin-compat/src",
              "@net": "prvdmwrong/net/src"
            }
          },
          "rule": "convert_require",
          "target": {
            "indexing_style": "property",
            "name": "roblox",
            "rojo_sourcemap": "./sourcemap.json"
          }
        },
        {
          "env": "PRVDMWRONG_VERSION",
          "identifier": "PRVDMWRONG_VERSION",
          "rule": "inject_global_value"
        },
        "compute_expression",
        "remove_unused_if_branch",
        "remove_unused_while",
        "filter_after_early_return",
        "remove_nil_declaration",
        "remove_empty_do"
      ]
    }

]]
