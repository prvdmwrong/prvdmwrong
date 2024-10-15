local types = require("./types")

local Config = {}

function Config.from(tomlData: any): types.Config
	assert(types.RawConfig(tomlData))
	return (tomlData :: types.RawConfig).config
end

return Config
