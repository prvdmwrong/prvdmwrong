local types = require("../types")

local function willFinish(root: types.Self, callback: () -> ())
	root._finish:register(callback)
	return root
end

return willFinish
