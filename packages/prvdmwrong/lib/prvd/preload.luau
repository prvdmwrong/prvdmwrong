--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local Log = require("prvdmwrong/utils/log")
local Types = require("prvdmwrong/types")

local IGNORE_NO_RETURNS = true

--[=[
  Preload the specified parent by requiring all ModuleScripts within it. An
  optional `predicate` function can be provided to filter modules.
]=]
local function preload(instances: { Instance }, predicate: ((ModuleScript) -> boolean)?)
  local exports: { unknown } = {}
  for _, module in instances do
    if not module:IsA("ModuleScript") then
      continue
    end
    if predicate and not predicate(module) then
      continue
    end

    local ok, result: Types.Error = xpcall(require, Log.parseError, module)
    if not ok then
      if IGNORE_NO_RETURNS and result.message:find("Module code did not return exactly one value") then
        Log.warn("requireError", module:GetFullName(), result.message)
      else
        Log.throw("requireError", result.trace, module:GetFullName(), result.message)
      end
    end

    table.insert(exports, result)
  end
  return exports
end

return preload
