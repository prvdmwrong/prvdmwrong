local Log = require("@scripts/_utils/log")
local buildTypes = require("@scripts/build/types")
local fs = require("@lune/fs")
local packages = require("@scripts/_packages")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local stdio = require("@lune/stdio")
local summon = require("@scripts/_utils/summon")
local types = require("@scripts/_types")

type Set<T> = { [T]: true }
type BrokenLuau = never

local PROCESSOR_PATH = path(process.cwd, "lune", "build", "processors")
local BUILD_DIRECTORY = path(process.cwd, "build")

if fs.isDir(BUILD_DIRECTORY) :: BrokenLuau then
	fs.removeDir(BUILD_DIRECTORY)
end

fs.writeDir(BUILD_DIRECTORY)

local processors: { buildTypes.Processor } = {}

for _, processorFile in fs.readDir(PROCESSOR_PATH) do
	local processorPath = path(PROCESSOR_PATH, processorFile)
	local processor = require(processorPath) :: any
	assert(buildTypes.Processor(processor))
	table.insert(processors, processor)
end

table.sort(processors, function(first: buildTypes.Processor, second: buildTypes.Processor)
	return (first.loadOrder or 1) < (second.loadOrder or 1)
end)

local nameToPackage: { [string]: types.Package } = {}

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

		local newPackage = package :: buildTypes.Package
		newPackage.outputPath = path(BUILD_DIRECTORY, newPackage.packageName)
		table.insert(resolved, newPackage)
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

local resolvedPackages = resolveDependencies(table.clone(packages))
local log = Log()
local context = {
	version = version,
	isDistributing = isDistributing,
	log = log,
}

summon("rojo", "sourcemap", "-o", "sourcemap.json", "default.project.json")
for _, processor in processors do
	log.print("Processing", processor.processesWhat)
	log.indent()
	for _, package in resolvedPackages do
		log.print("Processing package", package.packageName)
		processor:process(package, context)
	end
	log.unIndent()
end

for _, processor in processors do
	if processor.postProcess then
		log.print("Postprocessing", processor.processesWhat)
		processor:postProcess(context)
	end
end
