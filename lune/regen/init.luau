local Log = require("@scripts/_utils/log")
local fs = require("@lune/fs")
local packages = require("@scripts/_packages")
local path = require("@scripts/_utils/path")
local process = require("@lune/process")
local regenTypes = require("@scripts/regen/types")

local GENERATOR_PATH = path(process.cwd, "lune", "regen", "generators")

local generators: { regenTypes.Generator } = {}
for _, generatorFile in fs.readDir(GENERATOR_PATH) do
	local generatorPath = path(GENERATOR_PATH, generatorFile)
	local generator = require(generatorPath) :: any
	assert(regenTypes.Generator(generator))
	table.insert(generators, generator)
end

table.sort(generators, function(first: regenTypes.Generator, second: regenTypes.Generator)
	return (first.loadOrder or 1) < (second.loadOrder or 1)
end)

local log = Log()
for _, generator in generators do
	generator:generate(packages, log)
end
