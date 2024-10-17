local types = require("@core/types")
local utils = require("@core/utils")

type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>

local handlers = {}

--[=[
    @within Prvd
    Spawns all callbacks of a lifecycle asynchronously.

    @param lifecycle Lifecycle<Args...> -- Lifecycle to spawn callbacks with.
    @param ... Args... -- Arguments to call the callbacks with.
]=]
function handlers.fireConcurrent<Args...>(lifecycle: Lifecycle<Args...>, ...: Args...)
	utils.spawnCallbacks(lifecycle.callbacks, ...)
end

--[=[
    @within Prvd
    Calls all callbacks of a lifecycle sequentially.

    @param lifecycle Lifecycle<Args...> -- Lifecycle to call callbacks with.
    @param ... Args... -- Arguments to call the callbacks with.
]=]
function handlers.fireSequential<Args...>(lifecycle: Lifecycle<Args...>, ...: Args...)
	for _, callback in ipairs(lifecycle.callbacks) do
		callback(...)
	end
end

return handlers
