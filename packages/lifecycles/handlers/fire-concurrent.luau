local runtime = require("../../runtime")
local types = require("../types")

local function fireConcurrent<Args...>(lifecycle: types.Lifecycle<Args...>, ...: Args...)
	for _, callback in lifecycle.callbacks do
		runtime.threadpool.spawn(callback, ...)
	end
end

return fireConcurrent
