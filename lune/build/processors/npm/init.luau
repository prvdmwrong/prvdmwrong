local configs = require("@lunescripts/_utils/configs")
local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local serde = require("@lune/serde")
local types = require("@lunescripts/types")

local baseManifest = require("@lunescripts/build/processors/npm/manifest")

local NPM = {} :: types.BuildProcessor

function NPM:process(package: types.BuildPackage)
  local newManifest = table.clone(baseManifest)
  newManifest.name = `@{configs.repoConfig.publish.scopes.npm}/{package.name}`
  newManifest.description = package.config.config.description
  newManifest.version = package.version

  local npmDependencies = {}

  for _, dependency in (package.config.config.dependencies or {}) :: { string } do
    npmDependencies[`@{configs.repoConfig.publish.scopes.npm}/{dependency}`] = package.version
  end

  newManifest.dependencies = npmDependencies
  newManifest.author = configs.repoConfig.publish.authors[1]
  -- HACK: this is stupid
  newManifest.repository.url = "git+" .. configs.repoConfig.publish.repository .. ".git"
  newManifest.license = configs.repoConfig.publish.license

  fs.writeFile(path(package.outputPath, "package.json"), serde.encode("json", newManifest))
end

function NPM:publish(package: types.BuildPackage) end

return NPM
