local logger = require("../logger")
local types = require("../types")

local function await<Args...>(lifecycle: types.Self<Args...>): Args...
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	local currentThread = coroutine.running()
	local function callback(...: Args...)
		lifecycle:unregister(callback)
		coroutine.resume(currentThread, ...)
	end
	lifecycle:register(callback)
	return coroutine.yield()
end

return await
