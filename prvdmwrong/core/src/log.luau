-- FIXME: Luau is very janky
local game: DataModel = game
local RunService = game:GetService("RunService")

local types = require("@core/types")

type Error = types.Error

local MESSAGE_INFO_URL = "https://prvdmwrong.github.io/prvdmwrong/0.2/api-reference/errors/#"
local MESSAGES = table.freeze {
	alreadyStarted = "This root has already been `start()`ed.",
	alreadyStopped = "This root has already been `stop()`ed.",
	cannotCreateProvider = "Cannot create the provider - %s.",
	destroyedTwice = "Cannot destroy %s more than twice.",
	onInitError = "Cannot initialize root provider %s - %s.",
	requireError = "Cannot require module %s - %s.",
	unknownError = "Unknown error: %s. This indicates Prvd 'M Wrong isn't reporting errors correctly, please file an issue.",
	useAfterDestroy = "Cannot use %s after it's destroyed.",
	useWasDeprecated = "`prvd.use(callback)` was deprecated, specify the provider directly instead.",
}

export type MessageId = keyof<typeof(MESSAGES)>

local function formatMessage(messageId: MessageId, trackback: string, ...: string): string
	local rawMessage: string = MESSAGES[messageId]
	if not rawMessage then
		rawMessage = MESSAGES.unknownError:format(messageId)
	end

	local message = `[Prvd 'M Wrong]: {rawMessage:format(...)}`
	if RunService:IsStudio() then
		message ..= `\nLearn more: {MESSAGE_INFO_URL}{messageId:lower()}`
	end
	message ..= `\nID: {messageId}\n---- Stack trace ----\n{trackback}`

	return (message:gsub("\n", "\n    "))
end

local log = {}

function log.verbose(messageId: MessageId, trackback: string?, ...: string)
	if not _G.PRVDMWRONG_VERBOSE then
		return
	end
	local trackback = trackback or debug.traceback(nil, 2)
	print(formatMessage(messageId, trackback, ...))
end

function log.warn(messageId: MessageId, trackback: string?, ...: string)
	local trackback = trackback or debug.traceback(nil, 2)
	warn(formatMessage(messageId, trackback, ...))
end

function log.error(messageId: MessageId, trackback: string?, ...: string)
	local trackback = trackback or debug.traceback(nil, 2)
	task.spawn(error, formatMessage(messageId, trackback, ...), 0)
end

function log.fatal(messageId: MessageId, trackback: string, ...: string): never
	local trackback = trackback or debug.traceback(nil, 2)
	error(formatMessage(messageId, trackback, ...), 0)
end

function log.parseError(err: string): types.Error
	return {
		raw = err,
		message = err:gsub("^.+:%d+:%s*", ""),
		trace = debug.traceback(nil, 3),
	}
end

return log
