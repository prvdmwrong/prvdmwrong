local lifecycleUsed = require("../hooks/lifecycle-used").callbacks
local lifecycles = require("../../lifecycles")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useLifecycles(root: types.Self, lifecycles: { lifecycles.Lifecycle })
	for _, lifecycle in lifecycles do
		root._rootLifecycles[lifecycle] = true
		threadpool.spawnCallbacks(lifecycleUsed, root, lifecycle)
	end
	return root
end

return useLifecycles
