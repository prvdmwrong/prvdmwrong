--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local build = require("./build")
local fs = require("@lune/fs")
local path = require("../utils/path")
local process = require("@lune/process")
local stdio = require("@lune/stdio")

local CWD = process.cwd

local packages = {}
for _, package in fs.readDir(path(CWD, "packages")) do
	if fs.isFile(path(CWD, "packages", package)) then
		continue
	end
	table.insert(packages, package)
end
table.sort(packages)

local selected = stdio.prompt("multiselect", "Select packages to build, or none to build all packages", packages)
local selectedPackages = {}
if #selected == 0 then
	selectedPackages = packages
else
	for _, index in ipairs(selected) do
		table.insert(selectedPackages, packages[index])
	end
end

local shouldCreateRbxms = stdio.prompt("confirm", "Create .rbxm models?")
local shouldRelease = stdio.prompt("confirm", "Release these packages to Wally/Pesde/NPM?")
local version = "0.0.0-dev"
if shouldRelease then
	local promptedVersion = stdio.prompt("text", "Semver version to publish as?")
	assert(promptedVersion:match("^(%d+)%.?(%d*)%.?(%d*)(.-)$") ~= nil, `{version} is not a valid semver version`)
	version = promptedVersion
end

build {
	packages = selectedPackages,
	shouldCreateRbxms = shouldCreateRbxms,
	shouldRelease = shouldRelease,
	version = version,
}
