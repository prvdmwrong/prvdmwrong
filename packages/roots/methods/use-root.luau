local rootUsed = require("../hooks/root-used").callbacks
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useRoot(root: types.Self, subRoot: types.Root)
	root._subRoots[subRoot] = true
	threadpool.spawnCallbacks(rootUsed, root, subRoot)
	return root
end

return useRoot
