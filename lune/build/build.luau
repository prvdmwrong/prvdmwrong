local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local process = require("@lune/process")
local summon = require("@lunescripts/utils/summon")
local types = require("@lunescripts/types")

local PATH_BUILD = path(process.cwd, "build")
local PATH_PROCESSORS = path(process.cwd, "lune", "build", "processors")

local build = {}
local processors: { types.BuildProcessor } = {}

for _, processor in fs.readDir(PATH_PROCESSORS) do
	local buildProcessor = require(path(PATH_PROCESSORS, processor)) :: any
	assert(types.BuildProcessor(buildProcessor))
	table.insert(processors, buildProcessor)
end

table.sort(processors, function(left: types.BuildProcessor, right: types.BuildProcessor)
	local leftOrder = left.loadOrder or 1
	local rightOrder = right.loadOrder or 1
	return leftOrder < rightOrder
end)

function build.buildPackages(context: {
	packages: { types.Package },
	isDistributing: boolean,
	version: string,
})
	if fs.isDir(PATH_BUILD) then
		fs.removeDir(PATH_BUILD :: string)
	end

	fs.writeDir(PATH_BUILD)
	print("Generating Rojo sourcemap")
	summon("rojo", "sourcemap", "-o", "sourcemap.json", "./default.project.json")

	local buildPackages = {}
	for _, package in context.packages do
		print("Building", package.relativePath)
		local outputPath = path(PATH_BUILD, package.name)
		fs.writeDir(outputPath)

		local buildPackage: types.BuildPackage = table.clone(package :: any)
		buildPackage.outputPath = outputPath
		buildPackage.version = context.version
		buildPackage.isDistributing = context.isDistributing

		table.insert(buildPackages, buildPackage)

		for _, processor in processors do
			processor:process(buildPackage)
		end
	end

	for _, processor in processors do
		if processor.postProcessing then
			processor:postProcessing(buildPackages)
		end
	end
end

return build
