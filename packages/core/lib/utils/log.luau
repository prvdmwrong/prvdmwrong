--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local RunService = game:GetService("RunService")

local Types = require("core/types")

local ERROR_URL = "prvdmwrong.github.io/prvdmwrong/latest/api-reference/errors#"
local ERRORS = table.freeze {
	alreadyStarted = "Cannot ignite more than once.",
	cannotRegister = "Cannot register provider; %s.",
	cannotRegisterLifecycle = "Cannot register lifecycle %s; %s.",
	compatDeprecated = "Use %s instead of %s; %s.",
	incompatibleVersion = "An incompatible core Prvd 'M Wrong package was found. Currently version %s, found version %s. Consider updating your installation.",
	invalidLoadParent = "`preload()` expects an instance.",
	invalidOnStartCallback = "`onStart()` expects a callback.",
	invalidRefVersion = "Cannot parse %s from the shared Prvd 'M Wrong reference, see if there is a corrupt installation.",
	luminMissingWorker = "%s is not a Lumin Framework worker.",
	noPrvd = "Cannot find the `@prvdmwrong/core` package, try requiring the core package earlier so other packages can reference it.",
	onInitError = "Cannot initialize %s; %s.",
	onMethodImplementedWasDeprecated = "`onMethodImplemented` was deprecated, use `onMethodAdded` for observing lifecycles or create a `Lifecycle`. This will be an error in future versions of Prvd 'M Wrong.",
	registerAfterStartup = "Cannot register providers after startup.",
	requireError = "Cannot require %s; %s.",
	unknownError = "Unknown error: %s. This indicates Prvd 'M Wrong isn't reporting errors correctly, please file an issue.",
	useWasDeprecated = "`prvd.use(callback)` was deprecated, specify the provider directly instead.",
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
