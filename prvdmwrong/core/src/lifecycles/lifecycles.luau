local types = require("@core/types")
local utils = require("@core/utils")

type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>
type Self<Args... = ...unknown> = Lifecycle<Args...> & {
	_isDestroyed: boolean,
	_selfRegistered: { (callback: (Args...) -> ()) -> () },
	_selfUnregistered: { (callback: (Args...) -> ()) -> () },
}

local DISALLOW_MULTIPLE_LISTENERS = true

local lifecycleRegistered = {}
local lifecycleUnregistered = {}
local lifecycleDestroying = {}

local lifecycles = {}
lifecycles.methodLifecycles = {} :: { [string]: { Lifecycle } }

local function findAndRemove<T>(from: { T }, toRemove: T)
	local oldIndex = table.find(from, toRemove)
	if oldIndex then
		table.remove(from, toRemove)
	end
end

local function register<Args...>(lifecycle: Self<Args...>, callback: (Args...) -> ())
	utils.assert(not lifecycle._isDestroyed, "useAfterDestroy", "Lifecycle")
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycle.callbacks, callback)
	end
	table.insert(lifecycle.callbacks, callback)
	utils.spawnCallbacks(lifecycle._selfRegistered, callback)
end

local function unregister<Args...>(lifecycle: Self<Args...>, callback: (Args...) -> ())
	utils.assert(not lifecycle._isDestroyed, "useAfterDestroy", "Lifecycle")
	local index = table.find(lifecycle.callbacks, callback)
	if index then
		table.remove(lifecycle.callbacks, index)
		utils.spawnCallbacks(lifecycle._selfUnregistered, callback)
	end
end

local function unregisterAll<Args...>(lifecycle: Self<Args...>)
	utils.assert(not lifecycle._isDestroyed, "useAfterDestroy", "Lifecycle")
	for _, callback in lifecycle.callbacks do
		utils.spawnCallbacks(lifecycle._selfUnregistered, callback)
	end
	table.clear(lifecycle.callbacks)
end

local function onRegistered<Args...>(lifecycle: Self<Args...>, listener: (callback: (Args...) -> ()) -> ())
	utils.assert(not lifecycle._isDestroyed, "useAfterDestroy", "Lifecycle")
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycle._selfRegistered, listener)
	end
	table.insert(lifecycle._selfRegistered, listener)
	return function()
		findAndRemove(lifecycle._selfRegistered, listener)
	end
end

local function onUnregistered<Args...>(lifecycle: Self<Args...>, listener: (callback: (Args...) -> ()) -> ())
	utils.assert(not lifecycle._isDestroyed, "useAfterDestroy", "Lifecycle")
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycle._selfUnregistered, listener)
	end
	table.insert(lifecycle._selfUnregistered, listener)
	return function()
		findAndRemove(lifecycle._selfUnregistered, listener)
	end
end

local function await<Args...>(lifecycle: Self<Args...>): Args...
	utils.assert(not lifecycle._isDestroyed, "useAfterDestroy", "Lifecycle")
	local currentThread = coroutine.running()
	local function callback(...: Args...)
		lifecycle:unregister(callback)
		coroutine.resume(currentThread, ...)
	end
	lifecycle:register(callback)
	return coroutine.yield()
end

local function destroy<Args...>(lifecycle: Self<Args...>)
	utils.assert(not lifecycle._isDestroyed, "destroyedTwice", "Lifecycle")
	findAndRemove(lifecycles.methodLifecycles[lifecycle.method], lifecycle)
	utils.spawnCallbacks(lifecycleDestroying, lifecycle)
	table.clear(lifecycle.callbacks)
	lifecycle._isDestroyed = true
end

--[=[
    @within Prvd
    Constructs and returns a new lifecycle object. Providers with the specified method will be registered.

    @param method string -- The provider method that this lifecycle should hook onto.
    @param onFire (lifecycle: Lifecycle<Args...>, Args...) -> () -- A method to fire the lifecycle method. It receives itself and the arguments passed to it.
    @return Lifecycle<Args...> -- A freshly constructed lifecycle object.
]=]
function lifecycles.lifecycle<Args...>(
	method: string,
	onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
): Lifecycle<Args...>
	local self = {
		_isDestroyed = false,
		_selfRegistered = {},
		_selfUnregistered = {},
		type = "Lifecycle",
		callbacks = {},
		fire = onFire,
		method = method,
		register = register,
		unregister = unregister,
		unregisterAll = unregisterAll,
		onRegistered = onRegistered,
		onUnregistered = onUnregistered,
		await = await,
		destroy = destroy,
	} :: Self<Args...>

	local methodlifecycles = lifecycles.methodLifecycles[method]
	if not methodlifecycles then
		local newMethodlifecycles = {}
		lifecycles.methodLifecycles[method] = newMethodlifecycles
		methodlifecycles = newMethodlifecycles
	end

	table.insert(methodlifecycles, self)
	table.freeze(self)
	return self
end

--[=[
    @within Prvd
    Called when an object registers a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.

    @param listener (lifecycle: Lifecycle<Args...>, callback: (Args...) -> () -- Called when any lifecycle registers a callback.
    @return () -> () -- A callback that when called removes the listener.
]=]
function lifecycles.onLifecycleRegistered<Args...>(
	listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()
): () -> ()
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleRegistered, listener)
	end

	table.insert(lifecycleRegistered, listener)

	return function()
		findAndRemove(lifecycleRegistered, listener)
	end
end

--[=[
    @within Prvd
    Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.

    @param listener (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> () -- Called when any lifecycle unregisters a callback.
    @return () -> () -- A callback that when called removes the listener.
]=]
function lifecycles.onLifecycleUnregistered<Args...>(
	listener: (
		lifecycle: Lifecycle<Args...>,
		callback: (Args...) -> ()
	) -> ()
): () -> ()
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleUnregistered, listener)
	end

	table.insert(lifecycleUnregistered, listener)

	return function()
		findAndRemove(lifecycleUnregistered, listener)
	end
end

--[=[
    @within Prvd
    Called when a lifecycle is being destroyed. Listeners are expected to be infallible and non-yielding. The listener receives the lifecycle.

    @param listener (destroyedLifecycle: Lifecycle<Args...>) -> () -- Called when any lifecycle is being destroyed.
    @return () -> () -- A callback that when called removes the listener.
]=]
function lifecycles.onLifecycleDestroying<Args...>(listener: (destroyedLifecycle: Lifecycle<Args...>) -> ()): () -> ()
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleDestroying, listener)
	end

	table.insert(lifecycleDestroying, listener)

	return function()
		findAndRemove(lifecycleDestroying, listener)
	end
end

return lifecycles
