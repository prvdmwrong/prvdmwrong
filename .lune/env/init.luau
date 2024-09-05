local darklua = require("./templates/darklua")
local darkluaDev = require("./templates/darklua-dev")
local fs = require("@lune/fs")
local process = require("@lune/process")
local serde = require("@lune/serde")
local settings = require("./templates/settings")

local function path(...: string)
	return table.concat({ ... }, "/")
end

local packages = fs.readDir(path(process.cwd, "packages"))
for index, package in packages do
	if not fs.isDir(path(process.cwd, "packages", package)) then
		table.remove(packages, index)
		continue
	end
end

table.sort(packages)

local sources = {}
sources["@lune/"] = "~/.lune/.typedefs/0.8.6/"
for _, package in packages do
	sources[package] = path("packages", package, "lib")
end

local newDarklua = table.clone(darklua)
darklua.bundle.require_mode.sources = sources

local newDarkluaDev = table.clone(darkluaDev)
type ConvertRequire = {
	current: {
		name: "path",
		sources: { [string]: string },
	},
	rule: "convert_require",
	target: {
		indexing_style: "property",
		name: "roblox",
		rojo_sourcemap: "./sourcemap.json",
	},
}

for _, rule in newDarkluaDev.rules do
	if typeof(rule) == "table" and rule.rule == "convert_require" then
		local convertRequire = rule :: ConvertRequire
		convertRequire.current.sources = sources
	end
end

local newSettings = table.clone(settings)
newSettings["luau-lsp.require.directoryAliases"] = sources

fs.writeFile(path(process.cwd, ".lune", "build", "darklua.dist.json"), serde.encode("json", newDarklua, true))
fs.writeFile(path(process.cwd, ".lune", "build", "darklua.dev.json"), serde.encode("json", newDarkluaDev, true))
fs.writeFile(path(process.cwd, "vscode", "settings.json"), serde.encode("json", newSettings, true))
