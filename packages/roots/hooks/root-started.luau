local types = require("../types")

local callbacks: { (root: types.Self) -> () } = {}

local function onRootStarted(listener: (root: types.Root) -> ()): () -> ()
	table.insert(callbacks, listener)
	return function()
		table.remove(callbacks, table.find(callbacks, listener))
	end
end

return table.freeze({
	callbacks = callbacks,
	onRootStarted = onRootStarted,
})
