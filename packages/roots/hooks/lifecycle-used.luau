local lifecycles = require("../../lifecycles")
local types = require("../types")

local callbacks: { (root: types.Self, provider: lifecycles.Lifecycle) -> () } = {}

local function onLifecycleUsed(listener: (root: types.Root, lifecycle: lifecycles.Lifecycle) -> ()): () -> ()
	table.insert(callbacks, listener)
	return function()
		table.remove(callbacks, table.find(callbacks, listener))
	end
end

return table.freeze({
	callbacks = callbacks,
	onLifecycleUsed = onLifecycleUsed,
})
