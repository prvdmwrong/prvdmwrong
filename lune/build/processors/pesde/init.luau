local configs = require("@lunescripts/_utils/configs")
local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local serde = require("@lune/serde")
local types = require("@lunescripts/types")

local baseManifest = require("@lunescripts/build/processors/pesde/manifest")

local function pesdeify(str: string): string
  return (str:gsub("-", "_"))
end

local Pesde = {} :: types.BuildProcessor

function Pesde:process(package: types.BuildPackage)
  local newManifest = table.clone(baseManifest)
  newManifest.name = `{configs.repoConfig.publish.scopes.npm}/{pesdeify(package.name)}`
  newManifest.description = package.config.config.description
  newManifest.version = package.version

  local pesdeDependencies = {}

  for _, dependency in (package.config.config.dependencies or {}) :: { string } do
    pesdeDependencies[pesdeify(dependency)] = {
      name = `{configs.repoConfig.publish.scopes.npm}/{pesdeify(dependency)}`,
      version = package.version,
    }
  end

  newManifest.dependencies = pesdeDependencies
  newManifest.authors = configs.repoConfig.publish.authors
  newManifest.repository = configs.repoConfig.publish.repository
  newManifest.license = configs.repoConfig.publish.license

  fs.writeFile(path(package.outputPath, "pesde.toml"), serde.encode("toml", newManifest))
end

function Pesde:publish(package: types.BuildPackage) end

return Pesde
