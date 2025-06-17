local logger = require("./logger")
local runtime = require("../runtime")
local types = require("./types")

local threadpool = runtime.threadpool

type Self<Args... = ...any> = types.Lifecycle<Args...> & {
	_isDestroyed: boolean,
	_selfRegistered: { (callback: (Args...) -> ()) -> () },
	_selfUnregistered: { (callback: (Args...) -> ()) -> () },
}

local lifecycleConstructed: { (constructedLifecycle: types.Lifecycle) -> () } = {}
local lifecycleRegistered: { (registeredLifecycle: types.Lifecycle) -> () } = {}
local lifecycleUnregistered: { (unregisteredLifecycle: types.Lifecycle) -> () } = {}
local lifecycleDestroying: { (destroyingLifecycle: types.Lifecycle) -> () } = {}

local methodLifecycles = {} :: { [string]: { types.Lifecycle } }

local function findAndRemove<T>(from: { T }, toRemove: T)
	local oldIndex = table.find(from, toRemove)
	if oldIndex then
		table.remove(from, oldIndex)
	end
end

local function register<Args...>(lifecycle: Self<Args...>, callback: (Args...) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycle.callbacks, callback)
	end
	table.insert(lifecycle.callbacks, callback)
	threadpool.spawnCallbacks(lifecycle._selfRegistered, callback)
end

local function unregister<Args...>(lifecycle: Self<Args...>, callback: (Args...) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	local index = table.find(lifecycle.callbacks, callback)
	if index then
		table.remove(lifecycle.callbacks, index)
		threadpool.spawnCallbacks(lifecycle._selfUnregistered, callback)
	end
end

local function unregisterAll<Args...>(lifecycle: Self<Args...>)
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	for _, callback in lifecycle.callbacks do
		threadpool.spawnCallbacks(lifecycle._selfUnregistered, callback)
	end
	table.clear(lifecycle.callbacks)
end

local function onRegistered<Args...>(lifecycle: Self<Args...>, listener: (callback: (Args...) -> ()) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycle._selfRegistered, listener)
	end
	table.insert(lifecycle._selfRegistered, listener)
	return function()
		findAndRemove(lifecycle._selfRegistered, listener)
	end
end

local function onUnregistered<Args...>(lifecycle: Self<Args...>, listener: (callback: (Args...) -> ()) -> ())
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycle._selfUnregistered, listener)
	end
	table.insert(lifecycle._selfUnregistered, listener)
	return function()
		findAndRemove(lifecycle._selfUnregistered, listener)
	end
end

local function await<Args...>(lifecycle: Self<Args...>): Args...
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.useAfterDestroy })
	end
	local currentThread = coroutine.running()
	local function callback(...: Args...)
		lifecycle:unregister(callback)
		coroutine.resume(currentThread, ...)
	end
	lifecycle:register(callback)
	return coroutine.yield()
end

local function destroy<Args...>(lifecycle: Self<Args...>)
	if lifecycle._isDestroyed then
		logger:fatalError({ template = logger.alreadyDestroyed })
	end
	findAndRemove(methodLifecycles[lifecycle.method], lifecycle)
	threadpool.spawnCallbacks(lifecycleDestroying, lifecycle)
	table.clear(lifecycle.callbacks)
	lifecycle._isDestroyed = true
end

function createLifecycle<Args...>(
	method: string,
	onFire: (lifecycle: types.Lifecycle<Args...>, Args...) -> ()
): types.Lifecycle<Args...>
	local self: Self<Args...> = {
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
	} :: any

	local methodlifecycles = methodLifecycles[method]
	if not methodlifecycles then
		local newMethodlifecycles = {}
		methodLifecycles[method] = newMethodlifecycles
		methodlifecycles = newMethodlifecycles
	end

	table.insert(methodlifecycles, self)

	for _, onLifecycleConstructed in lifecycleConstructed do
		onLifecycleConstructed(self :: types.Lifecycle)
	end

	return self
end

function onLifecycleRegistered<Args...>(
	listener: (lifecycle: types.Lifecycle<Args...>, callback: (Args...) -> ()) -> ()
): () -> ()
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleRegistered, listener :: any)
	end

	table.insert(lifecycleRegistered, listener :: any)

	return function()
		findAndRemove(lifecycleRegistered, listener :: any)
	end
end

function onLifecycleUnregistered<Args...>(
	listener: (lifecycle: types.Lifecycle<Args...>, callback: (Args...) -> ()) -> ()
): () -> ()
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleUnregistered, listener :: any)
	end

	table.insert(lifecycleUnregistered, listener :: any)

	return function()
		findAndRemove(lifecycleUnregistered, listener :: any)
	end
end

function onLifecycleConstructing<Args...>(listener: (constructedLifecycle: types.Lifecycle<Args...>) -> ()): () -> ()
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleConstructed, listener)
	end

	table.insert(lifecycleConstructed, listener)

	return function()
		findAndRemove(lifecycleConstructed, listener)
	end
end

function onLifecycleDestroying<Args...>(listener: (destroyedLifecycle: types.Lifecycle<Args...>) -> ()): () -> ()
	if _G.PRVDMWRONG_DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleDestroying, listener)
	end

	table.insert(lifecycleDestroying, listener)

	return function()
		findAndRemove(lifecycleDestroying, listener)
	end
end

return table.freeze({
	createLifecycle = createLifecycle,

	onLifecycleRegistered = onLifecycleRegistered,
	onLifecycleUnregistered = onLifecycleUnregistered,
	onLifecycleConstructing = onLifecycleConstructing,
	onLifecycleDestroying = onLifecycleDestroying,

	methodLifecycles = methodLifecycles,
})
