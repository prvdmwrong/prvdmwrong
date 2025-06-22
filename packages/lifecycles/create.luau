local await = require("./methods/await")
local clear = require("./methods/unregister-all")
local destroy = require("./methods/destroy")
local lifecycleConstructed = require("./hooks/lifecycle-constructed")
local methodToLifecycles = require("./method-to-lifecycles")
local onRegistered = require("./methods/on-registered")
local onUnregistered = require("./methods/on-unregistered")
local register = require("./methods/register")
local types = require("./types")
local unregister = require("./methods/unregister")

local function create<Args...>(
	method: string,
	onFire: (lifecycle: types.Lifecycle<Args...>, Args...) -> ()
): types.Lifecycle<Args...>
	local self: types.Self<Args...> = {
		_isDestroyed = false,
		_selfRegistered = {},
		_selfUnregistered = {},

		type = "Lifecycle",
		callbacks = {},

		fire = onFire,
		method = method,
		register = register,
		unregister = unregister,
		clear = clear,
		onRegistered = onRegistered,
		onUnregistered = onUnregistered,
		await = await,
		destroy = destroy,
	} :: any

	methodToLifecycles[method] = methodToLifecycles[method] or {}
	table.insert(methodToLifecycles[method], self)

	for _, onLifecycleConstructed in lifecycleConstructed.callbacks do
		onLifecycleConstructed(self :: types.Lifecycle)
	end

	return self
end

return create
