local implementations = require("../implementations")

export type TaskLib = {
	cancel: (thread) -> (),
	defer: <T...>(functionOrThread: thread | (T...) -> (), T...) -> thread,
	delay: <T...>(duration: number, functionOrThread: thread | (T...) -> (), T...) -> thread,
	spawn: <T...>(functionOrThread: thread | (T...) -> (), T...) -> thread,
	wait: (duration: number?) -> number,
}

local supportedRuntimes = implementations.supportedRuntimes
local implementFunction = implementations.implementFunction

local function defaultSpawn<T...>(functionOrThread: thread | (T...) -> (), ...: T...): thread
	if type(functionOrThread) == "thread" then
		coroutine.resume(functionOrThread, ...)
		return functionOrThread
	else
		local thread = coroutine.create(functionOrThread)
		coroutine.resume(thread, ...)
		return thread
	end
end

local function defaultWait(seconds: number?)
	local startTime = os.clock()
	local endTime = startTime + (seconds or 1)
	local clockTime: number
	repeat
		clockTime = os.clock()
	until clockTime >= endTime
	return clockTime - startTime
end

local task: TaskLib = table.freeze({
	cancel = implementFunction("task.wait", {
		[supportedRuntimes.roblox] = {
			new = function()
				return task.cancel
			end,
		},
		[supportedRuntimes.lune] = {
			new = function()
				return require("@lune/task").cancel
			end,
		},
		[supportedRuntimes.zune] = {
			new = function()
				return require("@zcore/task").cancel
			end,
		},
		[supportedRuntimes.luau] = {
			implementation = function(thread)
				if not coroutine.close(thread) then
					error(debug.traceback(thread, "Could not cancel thread"))
				end
			end,
		},
	}),
	defer = implementFunction("task.defer", {
		[supportedRuntimes.roblox] = {
			new = function()
				return task.defer :: any
			end,
		},
		[supportedRuntimes.lune] = {
			new = function()
				return require("@lune/task").defer
			end,
		},
		[supportedRuntimes.zune] = {
			new = function()
				return require("@zcore/task").defer
			end,
		},
		[supportedRuntimes.luau] = {
			implementation = defaultSpawn,
		},
	}),
	delay = implementFunction("task.delay", {
		[supportedRuntimes.roblox] = {
			new = function()
				return task.delay :: any
			end,
		},
		[supportedRuntimes.lune] = {
			new = function()
				return require("@lune/task").delay
			end,
		},
		[supportedRuntimes.zune] = {
			new = function()
				return require("@zcore/task").delay
			end,
		},
		[supportedRuntimes.luau] = {
			implementation = function<T...>(duration: number, functionOrThread: thread | (T...) -> (), ...: T...): thread
				return defaultSpawn(
					if typeof(functionOrThread) == "function"
						then function(duration, functionOrThread, ...)
							defaultWait(duration)
							functionOrThread(...)
						end
						else function(duration, functionOrThread, ...)
							defaultWait(duration)
							coroutine.resume(...)
						end,
					duration,
					functionOrThread,
					...
				)
			end,
		},
	}),
	spawn = implementFunction("task.spawn", {
		[supportedRuntimes.roblox] = {
			new = function()
				return task.spawn :: any
			end,
		},
		[supportedRuntimes.lune] = {
			new = function()
				return require("@lune/task").spawn
			end,
		},
		[supportedRuntimes.zune] = {
			new = function()
				return require("@zcore/task").spawn
			end,
		},
		[supportedRuntimes.luau] = {
			implementation = defaultSpawn,
		},
	}),
	wait = implementFunction("task.wait", {
		[supportedRuntimes.roblox] = {
			new = function()
				return task.wait
			end,
		},
		[supportedRuntimes.lune] = {
			new = function()
				return require("@lune/task").wait
			end,
		},
		[supportedRuntimes.zune] = {
			new = function()
				return require("@zcore/task").wait
			end,
		},
		[supportedRuntimes.luau] = {
			implementation = defaultWait,
		},
	}),
})

return task
