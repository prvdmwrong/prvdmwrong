local types = require("./types")

local Config = {}

function Config.from(tomlData: any): types.Config
	assert(types.Config(tomlData))
	return tomlData
end

return Config
