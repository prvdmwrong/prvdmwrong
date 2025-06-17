local types = require("../types")

local function willStart(root: types.Self, callback: () -> ())
	root._start:register(callback)
	return root
end

return willStart
