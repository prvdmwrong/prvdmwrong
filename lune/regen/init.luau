local config = require("@lunescripts/regen/config")
local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local types = require("@lunescripts/regen/types")

local PATH_PACKAGES_RELATIVE = path("prvdmwrong")
local PATH_PACKAGES = path(process.cwd, PATH_PACKAGES_RELATIVE)
local PATH_GENERATORS = path(process.cwd, "lune", "regen", "generators")

local packages: { types.PackageData } = {}
local generators: { types.Generator } = {}

for _, package in fs.readDir(PATH_PACKAGES) do
  if not fs.isDir(path(PATH_PACKAGES, package)) then
    continue
  end

  local configPath = path(PATH_PACKAGES, package, "config.toml")
  assert(fs.isFile(configPath), `Missing prvdmwrong/{package} config.toml`)
  local packageConfig = config.from(serde.decode("toml", fs.readFile(assert(configPath, "Luau is wilding"))))

  table.insert(packages, {
    name = package,
    config = packageConfig,
    absolutePath = path(PATH_PACKAGES, package),
    relativePath = path(PATH_PACKAGES_RELATIVE, package),
  })
end

for _, generatorFile in fs.readDir(PATH_GENERATORS) do
  local generatorPath = path(PATH_GENERATORS, generatorFile)
  local generator = require(generatorPath) :: any
  assert(types.Generator(generator))
  table.insert(generators, generator)
end

table.sort(generators, function(first: types.Generator, second: types.Generator)
  return (first.loadOrder or 1) < (second.loadOrder or 1)
end)

for _, generator in generators do
  print("Generating", generator.of)
  generator:generate(packages)
end
