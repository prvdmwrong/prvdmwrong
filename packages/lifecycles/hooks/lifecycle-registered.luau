local types = require("../types")

local callbacks: { (lifecycle: types.Lifecycle, callback: (...unknown) -> ()) -> () } = {}

local function onLifecycleRegistered<Args...>(
	listener: (
		lifecycle: types.Lifecycle<Args...>,
		callback: (Args...) -> ()
	) -> ()
): () -> ()
	table.insert(callbacks, listener :: any)
	return function()
		table.remove(callbacks, table.find(callbacks, listener :: any))
	end
end

return table.freeze({
	callbacks = callbacks,
	onLifecycleRegistered = onLifecycleRegistered,
})
