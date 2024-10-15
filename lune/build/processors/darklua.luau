local path = require("@lunescripts/utils/path")
local process = require("@lune/process")
local types = require("@lunescripts/types")

local PATH_DARKLUA = path(process.cwd, "darklua.json")

local Darklua = {} :: types.BuildProcessor
Darklua.loadOrder = 0

function Darklua:process(package: types.BuildPackage)
  print("  Building package via Darklua")
  local darkluaProcess = process.spawn(
    "darklua",
    { "process", "-c", PATH_DARKLUA, "-vv", path(package.absolutePath, "src"), path(package.outputPath, "src") },
    {
      env = {
        PRVDMWRONG_BUILD = tostring(package.isDistributing),
        PRVDMWRONG_VERSION = package.version,
      },
      cwd = process.cwd,
      shell = true,
    } :: process.SpawnOptions
  )

  if not darkluaProcess.ok then
    print(darkluaProcess.stdout)
    print(darkluaProcess.stderr)
    print("Darklua process failed with code", tostring(darkluaProcess.code))
    process.exit(1)
  end
end

return Darklua
