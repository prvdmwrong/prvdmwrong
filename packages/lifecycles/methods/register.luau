local logger = require("../logger")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function register<Args...>(lifecycle: types.Self<Args...>, callback: (Args...) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		table.remove(lifecycle.callbacks, table.find(lifecycle.callbacks, callback))
	end
	table.insert(lifecycle.callbacks, callback)
	threadpool.spawnCallbacks(lifecycle._selfRegistered, callback)
end

return register
