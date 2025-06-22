local lifecycleDestroyed = require("../hooks/lifecycle-destroyed")
local logger = require("../logger")
local methodToLifecycles = require("../method-to-lifecycles")
local types = require("../types")

local function destroy<Args...>(lifecycle: types.Self<Args...>)
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.alreadyDestroyed })
	end
	table.remove(methodToLifecycles[lifecycle.method], table.find(methodToLifecycles[lifecycle.method], lifecycle))
	table.clear(lifecycle.callbacks)
	for _, callback in lifecycleDestroyed.callbacks do
		callback(lifecycle)
	end
	lifecycle._isDestroyed = true
end

return destroy
