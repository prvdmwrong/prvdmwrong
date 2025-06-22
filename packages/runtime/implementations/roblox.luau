local types = require("../types")

return types.Runtime({
	name = "roblox",
	is = function()
		-- wtf
		return not not (_VERSION == "Luau" and game and workspace)
	end,
})
