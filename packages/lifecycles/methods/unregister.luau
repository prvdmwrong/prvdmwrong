local logger = require("../logger")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function unregister<Args...>(lifecycle: types.Self<Args...>, callback: (Args...) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	local index = table.find(lifecycle.callbacks, callback)
	if index then
		table.remove(lifecycle.callbacks, index)
		threadpool.spawnCallbacks(lifecycle._selfUnregistered, callback)
	end
end

return unregister
