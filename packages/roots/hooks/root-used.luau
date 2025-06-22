local types = require("../types")

local callbacks: { (root: types.Self, subRoot: types.Root) -> () } = {}

local function onRootUsed(listener: (root: types.Root, subRoot: types.Root) -> ()): () -> ()
	table.insert(callbacks, listener)
	return function()
		table.remove(callbacks, table.find(callbacks, listener))
	end
end

return table.freeze({
	callbacks = callbacks,
	onRootUsed = onRootUsed,
})
