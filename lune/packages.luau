local configs = require("@scripts/_configs")
local fs = require("@lune/fs")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local types = require("@scripts/_types")

-- Alias for types that breaks Luau solver v2
type BrokenLuau = never

export type Package = {
	packageName: string,
	absolutePath: string,
	relativePath: string,
	config: types.Config,
}

local PACKAGES_RELATIVE = "prvdmwrong"
local PACKAGES_ABSOLUTE = path(process.cwd, PACKAGES_RELATIVE)

local packages: { types.Package } = {}

for _, foundPackage in fs.readDir(PACKAGES_ABSOLUTE) do
	local packagePath = path(PACKAGES_ABSOLUTE, foundPackage)
	local configPath = path(PACKAGES_ABSOLUTE, foundPackage, "prvdmwrong.toml")

	if not fs.isDir(packagePath) :: BrokenLuau or not fs.isFile(configPath) :: BrokenLuau then
		continue
	end

	local config = configs.assertToml(serde.decode("toml", fs.readFile(configPath)))
	table.insert(packages, {
		packageName = foundPackage,
		absolutePath = packagePath,
		relativePath = path(PACKAGES_RELATIVE, foundPackage),
		config = config,
	})
end

table.sort(packages, function(left, right)
	return left.packageName < right.packageName
end)

table.freeze(packages)
return packages
