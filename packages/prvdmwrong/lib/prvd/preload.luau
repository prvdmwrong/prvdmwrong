--!strict
-- (c) Prvd 'M Wrong, dual-licensed under Apache 2.0 and MIT terms.

local Types = require("prvdmwrong/types")
local log = require("prvdmwrong/utils/log")

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

    local ok, result: Types.Error = xpcall(require, log.parseError, module)
    if not ok then
      if IGNORE_NO_RETURNS and result.message:find("Module code did not return exactly one value") then
        log.warn("requireError", module:GetFullName(), result.message)
      else
        log.throw("requireError", module:GetFullName(), result.message)
      end
    end

    table.insert(exports, result)
  end
  return exports
end

return preload
