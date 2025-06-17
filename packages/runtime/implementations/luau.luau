local types = require("../types")

return types.Runtime({
	name = "luau",
	priority = -1,
	is = function()
		return true
	end,
})
