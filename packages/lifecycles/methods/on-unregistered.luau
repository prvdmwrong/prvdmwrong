local logger = require("../logger")
local types = require("../types")

local function onUnregistered<Args...>(lifecycle: types.Self<Args...>, listener: (callback: (Args...) -> ()) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		table.remove(lifecycle._selfUnregistered, table.find(lifecycle._selfUnregistered, listener))
	end
	table.insert(lifecycle._selfUnregistered, listener)
	return function()
		table.remove(lifecycle._selfUnregistered, table.find(lifecycle._selfUnregistered, listener))
	end
end

return onUnregistered
