local types = require("../types")

local function fireSequential<Args...>(lifecycle: types.Lifecycle<Args...>, ...: Args...)
	for _, callback in lifecycle.callbacks do
		callback(...)
	end
end

return fireSequential
