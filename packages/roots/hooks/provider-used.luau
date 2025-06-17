local providers = require("../../providers")
local types = require("../types")

local callbacks: { (root: types.Self, provider: providers.Provider<unknown>) -> () } = {}

local function onProviderUsed(listener: (root: types.Root, provider: providers.Provider<unknown>) -> ()): () -> ()
	table.insert(callbacks, listener)
	return function()
		table.remove(callbacks, table.find(callbacks, listener))
	end
end

return table.freeze({
	callbacks = callbacks,
	onProviderUsed = onProviderUsed,
})
