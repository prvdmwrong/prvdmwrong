local types = require("./types")

local function nameOf(provider: types.Provider<any, any>)
	return provider.name or "Provider"
end

return nameOf
