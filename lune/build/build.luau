local fs = require("@lune/fs")
local path = require("@lunescripts/utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")
local summon = require("@lunescripts/utils/summon")
local types = require("@lunescripts/types")

local PATH_BUILD = path(process.cwd, "build")
local DARKLUA_DEV = path(process.cwd, "lune", "build", "darklua", "dev.json")
local DARKLUA_DIST = path(process.cwd, "lune", "build", "darklua", "dist.json")

local build = {}

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

  local darkluaConfig = context.isDistributing and DARKLUA_DIST or DARKLUA_DEV

  for _, package in context.packages do
    print("Building", package.relativePath)
    local outputPath = path(PATH_BUILD, package.name)
    fs.writeDir(outputPath)

    summon(
      "darklua",
      "process",
      "-c",
      darkluaConfig,
      "-vvvv",
      path(package.absolutePath, "src"),
      path(outputPath, "src")
    )
  end
end

return build
