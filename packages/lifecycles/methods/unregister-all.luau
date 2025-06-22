local logger = require("../logger")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function clear<Args...>(lifecycle: types.Self<Args...>)
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	for _, callback in lifecycle.callbacks do
		threadpool.spawnCallbacks(lifecycle._selfUnregistered, callback)
	end
	table.clear(lifecycle.callbacks)
end

return clear
