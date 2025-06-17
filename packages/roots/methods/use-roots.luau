local rootUsed = require("../hooks/root-used").callbacks
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useRoots(root: types.Self, subRoots: { types.Root })
	for _, subRoot in subRoots do
		root._subRoots[subRoot] = true
		threadpool.spawnCallbacks(rootUsed, root, subRoot)
	end
	return root
end

return useRoots
