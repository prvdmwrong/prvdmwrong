local fs = require("@lune/fs")
local path = require("../utils/path")
local process = require("@lune/process")
local serde = require("@lune/serde")
local types = require("./types")

local PATH_ROOT_CONFIG = path(process.cwd, "config.toml")

local ok, result = pcall(function(): types.RootConfig
  local rootConfig = serde.decode("toml", fs.readFile(PATH_ROOT_CONFIG))
  assert(types.RootConfig(rootConfig :: any))
  return assert(rootConfig, "Luau")
end)

if not ok then
  error("Failed to read Prvd 'M Wrong doc.toml: " .. result :: any)
end

return result
