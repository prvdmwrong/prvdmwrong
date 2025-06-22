local types = require("../types")

local LUNE_VERSION_FORMAT = "(Lune) (%d+%.%d+%.%d+.*)+(%d+)"

return types.Runtime({
	name = "lune",
	is = function()
		return string.match(_VERSION, LUNE_VERSION_FORMAT) ~= nil
	end,
})
