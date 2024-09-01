--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local assertion = require("../utils/assertion")
local color = require("../utils/color")
local fs = require("@lune/fs")
local path = require("../utils/path")
local process = require("@lune/process")
local roblox = require("@lune/roblox")
local summon = require("../utils/summon")

local templates = require("./templates")

local CWD = process.cwd
local DIST_DIRECTORY = path(CWD, "dist")
local SCOPE = "prvdmwrong"

local function build(props: {
	packages: { string },
	shouldCreateRbxms: boolean,
	shouldRelease: boolean,
	version: string,
})
	-- stylua: ignore
	local packages, shouldCreateRbxms, shouldRelease, version = props.packages, props.shouldCreateRbxms, props.shouldRelease, props.version
	assertion(version:match("^(%d+)%.?(%d*)%.?(%d*)(.-)$") ~= nil, `{version} is not a valid semver version`)

	local target = shouldRelease and version or "development"
	print(color.yellow("[Prvd 'M Wrong]"), "Building", table.concat(packages, ", "), "for", target)

	if fs.isDir(DIST_DIRECTORY) then
		print(color.yellow("[Prvd 'M Wrong]"), "Deleting dist folder")
		assertion(pcall(fs.removeDir, DIST_DIRECTORY))
	end

	print(color.yellow("[Prvd 'M Wrong]"), "Generating bundle sourcemap")
	summon("rojo", "sourcemap", path(CWD, "default.project.json"), "-o", path(CWD, "sourcemap.json"))

	local bundle = roblox.Instance.new("Model")
	bundle.Name = "prvdmwrong-bundle"

	local darkluaConfig = path(CWD, shouldRelease and ".darklua.json" or ".darklua-dev.json")
	fs.writeDir(DIST_DIRECTORY)

	for _, package in props.packages do
		if fs.isDir(path(CWD, "dist", package)) then
			continue
		end

		print(color.blue(`[Prvd 'M Wrong > {package}]`), "Processing", package)
		fs.writeDir(path(CWD, "dist", package))
		summon(
			"darklua",
			"process",
			shouldRelease and path(CWD, "dist", package, "lib", "init.luau") or path(CWD, "packages", package, "lib"),
			shouldRelease and path(CWD, "dist", package, "lib", "init.lua") or path(CWD, "dist", package, "lib"),
			"-c",
			darkluaConfig,
			"-v"
		)

		print(color.blue(`[Prvd 'M Wrong > {package}]`), "Writing default.project.json")
		local projectFile = table.clone(templates.project)
		projectFile.name = `{SCOPE}-{package}`
	end
end

return build
