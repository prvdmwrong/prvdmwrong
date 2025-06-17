local types = require("../types")

local callbacks: { (root: types.Self, root: types.Root) -> () } = {}

local function onRootUsed(listener: (root: types.Root, root: types.Root) -> ()): () -> ()
	table.insert(callbacks, listener)
	return function()
		table.remove(callbacks, table.find(callbacks, listener))
	end
end

return table.freeze({
	callbacks = callbacks,
	onRootUsed = onRootUsed,
})
