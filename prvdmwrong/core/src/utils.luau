local log = require("@core/log")
local messages = require("@core/messages")

local utils = {}

do
	local freeThreads: { thread } = {}
	local function resume<Args...>(resume: (Args...) -> (), thread: thread, ...: Args...)
		resume(...)
		table.insert(freeThreads, thread)
	end

	local function yield()
		while true do
			resume(coroutine.yield())
		end
	end

	function utils.spawnCallback<Args...>(callback: (Args...) -> (), ...: Args...)
		local thread: thread
		if #freeThreads > 0 then
			thread = assert(table.remove(freeThreads, #freeThreads), "Luau")
		else
			thread = coroutine.create(yield)
			coroutine.resume(thread)
		end
		task.spawn(thread, callback, thread, ...)
	end
end

function utils.spawnCallbacks<Args...>(callbacks: { (Args...) -> () }, ...: Args...)
	for _, callback in callbacks do
		utils.spawnCallback(callback, ...)
	end
end

function utils.assert<T>(value: T, messageId: messages.Message, ...: string)
	if value then
		return value
	end
	return log.fatal(messageId, debug.traceback(nil, 3), ...)
end

function utils.findAndRemove<T>(from: { T }, toRemove: T)
	local oldIndex = table.find(from, toRemove)
	if oldIndex then
		table.remove(from, toRemove)
	end
end

table.freeze(utils)
return utils
