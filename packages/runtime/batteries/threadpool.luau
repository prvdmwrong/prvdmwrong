local task = require("../libs/task")

local freeThreads: { thread } = {}

local function run<T...>(f: (T...) -> (), thread: thread, ...)
	f(...)
	table.insert(freeThreads, thread)
end

local function yielder()
	while true do
		run(coroutine.yield())
	end
end

local function spawn<T...>(f: (T...) -> (), ...: T...)
	local thread
	if #freeThreads > 0 then
		thread = freeThreads[#freeThreads]
		freeThreads[#freeThreads] = nil
	else
		thread = coroutine.create(yielder)
		coroutine.resume(thread)
	end

	task.spawn(thread, f, thread, ...)
end

return table.freeze({
	spawn = spawn,
})
