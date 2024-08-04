--!strict
--[[
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
]]

local RunService = game:GetService("RunService")
local Types = require(script.Parent.types)

local ERROR_MESSAGES_URL = "team-fireworks.github.io/ohmyprvd/latest/reference/error-messages#"

local MESSAGES = table.freeze {
  alreadyStarted = "cannot ignite more than once",
  cannotRegister = "cannot register provider; %s",
  cannotRegisterLifecycle = "cannot register lifecycle %s; %s",
  cannotUseNonProvider = "`prvd.use(provider)` must be given a provider",
  invalidLoadParent = "preload must be given an instance",
  invalidOnStartCallback = "`prvd.onStart(callback)` expects a callback",
  multipleInstalls = "there are multiple installations of ohmyprvd, this can lead to unexpected behavior",
  onInitError = "cannot initialize %s; %s",
  onMethodImplementedWasDeprecated = "`onMethodImplemented` was deprecated, use `onMethodAdded` for observing lifecycles or `Lifecycle` for implementing lifecycles",
  registerAfterStartup = "cannot register providers after startup",
  requireError = "cannot require %s; %s",
  unknownError = "unknown error: %s",
  useAfterStartup = "cannot use other providers after startup",
  usedBeforeStartup = 'cannot use provider "%s" prior to startup',
}

local TIPS = table.freeze {
  unknownError = "this indicates ohmyprvd isn't reporting errors correctly, please file an issue",
  usedBeforeStartup = "ohmyprvd will inject the dependency for you during runtime, its safe to use the provider inside a lifecycle method",
  onMethodImplementedWasDeprecated = "this will be an error in future versions of oh my prvd",
}

local Log = {}

local function formatError(id: string, trace: string?, ...: unknown)
  local message = MESSAGES[id]
  if not message then
    local unknownMessage = table.clone(MESSAGES.unknownError)
    unknownMessage = unknownMessage:format(id)
    message = unknownMessage
    id = "unknownError"
  end

  local formatted = `[OMP({id})]: {message}`
  if select("#", ...) > 0 then
    formatted = formatted:format(...)
  end
  if TIPS[id] then
    formatted ..= `\nhelp: {TIPS[id]}`
  end
  if RunService:IsStudio() then
    formatted ..= `\nlearn more: {ERROR_MESSAGES_URL}{id:lower()}`
  end
  if trace then
    formatted ..= `\nstack trace:\n{(trace:gsub("\n", "\n    "))}`
  end

  return (formatted:gsub("\n", "\n    "))
end

--[[
  Throws an error, halting further execution.
]]
function Log.throw(id: string, trace: string?, ...: unknown): never
  error(formatError(id, trace or debug.traceback(nil, 3), ...), 0)
end

--[[
  Logs a warning message to the output.
]]
function Log.warn(id: string, ...: unknown)
  warn(formatError(id, nil, ...))
end

--[[
  An `xpcall` handler used to extract useful information such as stack traces
  and messages.
]]
function Log.parseError(err: string): Types.Error
  return {
    type = "Error",
    raw = err,
    message = err:gsub("^.+:%d+:%s*", ""),
    trace = debug.traceback(nil, 3),
  }
end

--[[
  Passes the condition if it is truthy, otherwise throws an error with the Log
  module. Behaves like a modified `assert`.
]]
function Log.expect<T>(condition: T, id: string, trace: string?, ...: unknown): T
  if condition then
    return condition
  end
  return Log.throw(id, trace, ...)
end

table.freeze(Log)
return Log
