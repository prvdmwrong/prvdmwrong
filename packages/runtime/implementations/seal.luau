local types = require("../types")

return types.Runtime({
	name = "seal",
	is = function()
		return false
	end,
})
