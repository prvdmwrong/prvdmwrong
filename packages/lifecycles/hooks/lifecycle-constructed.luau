local types = require("../types")

local callbacks: { (lifecycle: types.Lifecycle) -> () } = {}

local function onLifecycleConstructed(listener: (lifecycle: types.Lifecycle) -> ()): () -> ()
	table.insert(callbacks, listener)
	return function()
		table.remove(callbacks, table.find(callbacks, listener))
	end
end

return table.freeze({
	callbacks = callbacks,
	onLifecycleConstructed = onLifecycleConstructed,
})
