local lifecycleUsed = require("../hooks/lifecycle-used").callbacks
local lifecycles = require("../../lifecycles")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useLifecycle(root: types.Self, lifecycle: lifecycles.Lifecycle)
	root._rootLifecycles[lifecycle] = true
	threadpool.spawnCallbacks(lifecycleUsed, root, lifecycle)
	return root
end

return useLifecycle
