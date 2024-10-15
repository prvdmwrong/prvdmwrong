local build = require("@lunescripts/build/build")
local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")
local types = require("@lunescripts/types")

type Set<T> = { [T]: true }

local PATH_PACKAGES_RELATIVE = path("prvdmwrong")
local PATH_PACKAGES = path(process.cwd, PATH_PACKAGES_RELATIVE)

local foundPackages: { string } = {}
for _, package in fs.readDir(PATH_PACKAGES) do
	local packagePath = path(PATH_PACKAGES, package)
	if not fs.isDir(packagePath) then
		continue
	end
	table.insert(foundPackages, package)
end

table.sort(foundPackages)
local packages = {}
local nameToPackage: { [string]: types.Package } = {}
local selectedPackages = assert(
	stdio.prompt("multiselect" :: "multiselect", "Select packages to build", foundPackages),
	"No packages to build"
)

assert(#selectedPackages > 0, "No packages selected to build")
for _, index in selectedPackages do
	local package = (foundPackages :: { string })[index]
	local absolutePath = path(PATH_PACKAGES, package)
	local config = serde.decode("toml", fs.readFile(path(absolutePath, "config.toml")))

	assert(types.Config(config))
	local packageData = {
		name = package,
		relativePath = path(PATH_PACKAGES_RELATIVE, package),
		absolutePath = absolutePath,
		config = config,
	}
	table.insert(packages, packageData)
	nameToPackage[package] = packageData
end

-- Dependencies need to be published before dependent packages are, thus resolve
-- these dependencies through topological sorting
local function resolveDependencies(): { types.Package }
	local visited: Set<types.Package> = {}
	local resolved: { types.Package } = {}

	local function resolvePackage(package: types.Package)
		visited[package] = true

		local dependencies = package.config.config.dependencies
		if dependencies then
			for _, dependentName in dependencies do
				local dependentPackage = nameToPackage[dependentName]
				if dependentPackage and not visited[dependentPackage] then
					resolvePackage(dependentPackage)
				end
			end
		end

		table.insert(resolved, package)
	end

	for _, package in packages do
		resolvePackage(package)
	end

	return resolved
end

local isDistributing = stdio.prompt("confirm" :: "confirm", "Distribute these packages to Wally/Pesde/NPM?") :: any
local version = "0.0.0"
if isDistributing then
	version = stdio.prompt("text" :: "text", "Enter a valid semver version to distribute")
end

build.buildPackages {
	packages = resolveDependencies(),
	isDistributing = isDistributing,
	version = version,
}
