local logger = require("../logger")
local types = require("../types")

local function onRegistered<Args...>(lifecycle: types.Self<Args...>, listener: (callback: (Args...) -> ()) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		table.remove(lifecycle._selfRegistered, table.find(lifecycle._selfRegistered, listener))
	end
	table.insert(lifecycle._selfRegistered, listener)
	return function()
		table.remove(lifecycle._selfRegistered, table.find(lifecycle._selfRegistered, listener))
	end
end

return onRegistered
