--!strict
-- The Prvd 'M Wrong project is dual-licensed under Apache 2.0 and MIT terms.

local RunService = game:GetService("RunService")

local Types = require("prvdmwrong/types")

local ERROR_URL = "prvdmwrong.github.io/prvdmwrong/latest/reference/errors#"
local ERRORS = table.freeze {
  luminDeprecated = "Use %s instead of %s; %s.",
  luminMissingWorker = "%s is not a Lumin Framework worker.",
  noPrvd = "Cannot find the `@prvdmwrong/core` package, try requiring the core package earlier so other packages can reference it.",
  unknownError = "Unknown error: %s. this indicates Prvd 'M Wrong isn't reporting errors correctly, please file an issue.",
}

local log = {}

local function formatError(id: string, trace: string?, ...: unknown)
  local message = ERRORS[id]
  if not message then
    message = ERRORS.unknownError:format(id)
    id = "unknownError"
  end

  local formatted = `[Prvd 'M Wrong]: {message}`
  formatted ..= `\nID: {id}`
  if select("#", ...) > 0 then
    formatted = formatted:format(...)
  end
  if RunService:IsStudio() then
    formatted ..= `\nLearn more: {ERROR_URL}{id:lower()}`
  end
  if trace then
    formatted ..= `\nStack trace:\n{(trace:gsub("\n", "\n    "))}`
  end

  return (formatted:gsub("\n", "\n    "))
end

--[=[
  Throws an error, halting further execution.
]=]
function log.throw(id: string, ...: unknown): never
  error(formatError(id, debug.traceback(nil, 3), ...), 0)
end

--[=[
  logs a warning message to the output.
]=]
function log.warn(id: string, ...: unknown)
  warn(formatError(id, debug.traceback(nil, 2), ...))
end

--[=[
  An `xpcall` handler used to extract useful information such as stack traces
  and messages.
]=]
function log.parseError(err: string): Types.Error
  return {
    type = "Error",
    raw = err,
    message = err:gsub("^.+:%d+:%s*", ""),
    trace = debug.traceback(nil, 3),
  }
end

--[=[
  Passes the condition if it is truthy, otherwise throws an error with the log
  module. Behaves like a modified `assert`.
]=]
function log.expect<T>(condition: T, id: string, ...: unknown): T
  if condition then
    return condition
  end
  return log.throw(id, debug.traceback(nil, 3), ...)
end

table.freeze(log)
return log
