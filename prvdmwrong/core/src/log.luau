-- FIXME: Luau is very janky
local game: DataModel = game
local RunService = game:GetService("RunService")

local messages = require("@core/messages")
local types = require("@core/types")

type Error = types.Error
type Message = messages.Message

local MESSAGE_INFO_URL = "https://prvdmwrong.github.io/prvdmwrong/0.2/api-reference/errors/#"

local function formatMessage(message: Message, trackback: string, ...: string): string
	local rawMessage: string = messages[message]
	if not rawMessage then
		rawMessage = messages.unknownError:format(message)
	end

	local message = `[Prvd 'M Wrong]: {rawMessage:format(...)}`
	if RunService:IsStudio() then
		message ..= `\nLearn more: {MESSAGE_INFO_URL}{message:lower()}`
	end
	message ..= `\nID: {message}\n---- Stack trace ----\n{trackback}`

	return (message:gsub("\n", "\n    "))
end

local log = {}

function log.verbose(message: Message, trackback: string?, ...: string)
	if not _G.PRVDMWRONG_VERBOSE then
		return
	end
	local trackback = trackback or debug.traceback(nil, 2)
	print(formatMessage(message, trackback, ...))
end

function log.warn(message: Message, trackback: string?, ...: string)
	local trackback = trackback or debug.traceback(nil, 2)
	warn(formatMessage(message, trackback, ...))
end

function log.error(message: Message, trackback: string?, ...: string)
	local trackback = trackback or debug.traceback(nil, 2)
	task.spawn(error, formatMessage(message, trackback, ...), 0)
end

function log.fatal(message: Message, trackback: string, ...: string): never
	local trackback = trackback or debug.traceback(nil, 2)
	error(formatMessage(message, trackback, ...), 0)
end

function log.parseError(err: string): types.Error
	return {
		raw = err,
		message = err:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 3),
	}
end

return log
