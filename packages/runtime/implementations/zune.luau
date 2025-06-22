local types = require("../types")

local ZUNE_VERSION_FORMAT = "(Zune) (%d+%.%d+%.%d+.*)+(%d+%.%d+)"

return types.Runtime({
	name = "zune",
	is = function()
		return string.match(_VERSION, ZUNE_VERSION_FORMAT) ~= nil
	end,
})
