local utils = require("@core/utils")

--[=[
  @within Lifecycles
  @interface Lifecycle<Args...>
  Aye, Mustard on the beat ho
]=]
export type Lifecycle<Args...> = {
	callbacks: { (Args...) -> () },
	method: string,
	type: "Lifecycle",

	register: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
	fire: (self: Lifecycle<Args...>, Args...) -> (),
	unregister: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
	unregisterAll: (self: Lifecycle<Args...>) -> (),
	onRegistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
	onUnregistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
	destroy: (self: Lifecycle<Args...>) -> (),
}

local DISALLOW_MULTIPLE_LISTENERS = false

local lifecycleRegistered = {}
local lifecycleUnregistered = {}
local lifecycleDestroying = {}

--[=[
  @class Lifecycles
  @since 0.2
  APIs for creating custom provider lifecycle events. Providers with a lifecycle's specified method will register that lifecycle event.
]=]
local Lifecycles = {}
Lifecycles.methodLifecycles = {} :: { [string]: { Lifecycle<...unknown> } }

local function findAndRemove<T>(from: { T }, toRemove: T)
	local oldIndex = table.find(from, toRemove)
	if oldIndex then
		table.remove(from, toRemove)
	end
end

--[=[
  Constructs and returns a new lifecycle object. Providers with the specified method will be registered.
  @since 0.2
  @param method string -- The provider method that this lifecycle should hook onto.
  @param onFire (lifecycle: Lifecycle<Args...>, Args...) -> () -- A method to fire the lifecycle method. It receives itself and the arguments passed to it.
  @return Lifecycle<Args...> -- A freshly constructed lifecycle object.
]=]
function Lifecycles.lifecycle<Args...>(
	method: string,
	onFire: (lifecycle: Lifecycle<Args...>, Args...) -> ()
): Lifecycle<Args...>
	local self = {} :: Lifecycle<Args...>
	self.callbacks = {}
	self.fire = onFire
	self.method = method
	self.type = "Lifecycle"

	local selfRegistered: { (Args...) -> () } = {}
	local selfUnregistered: { (Args...) -> () } = {}
	local isDestroyed = false

	function self:register(callback)
		utils.assert(not isDestroyed, "cannot register listeners after a lifecycle is destroyed")
		if DISALLOW_MULTIPLE_LISTENERS then
			findAndRemove(self.callbacks, callback)
		end
		table.insert(self.callbacks, callback)
		utils.spawnCallbacks(selfRegistered, callback)
	end

	function self:unregister(callback)
		utils.assert(not isDestroyed, "cannot unregister listeners after a lifecycle is destroyed")
		local index = table.find(self.callbacks, callback)
		if index then
			table.remove(self.callbacks, index)
			utils.spawnCallbacks(selfUnregistered, callback)
		end
	end

	function self:unregisterAll()
		utils.assert(not isDestroyed, "cannot unregister all listeners after a lifecycle is destroyed")
		for _, callback in self.callbacks do
			utils.spawnCallbacks(selfUnregistered, callback)
		end
		table.clear(self.callbacks)
	end

	function self:onRegistered(listener)
		utils.assert(not isDestroyed, "cannot hook onto a lifecycle is destroyed")
		if DISALLOW_MULTIPLE_LISTENERS then
			findAndRemove(selfRegistered, listener)
		end
		table.insert(selfRegistered, listener)
		return function()
			findAndRemove(selfRegistered, listener)
		end
	end

	function self:onUnregistered(listener)
		utils.assert(not isDestroyed, "cannot hook onto a lifecycle is destroyed")
		if DISALLOW_MULTIPLE_LISTENERS then
			findAndRemove(selfUnregistered, listener)
		end
		table.insert(selfUnregistered, listener)
		return function()
			findAndRemove(selfUnregistered, listener)
		end
	end

	function self:destroy()
		utils.assert(not isDestroyed, "cannot destroy a lifecycle twice")
		findAndRemove(Lifecycles.methodLifecycles[method], self)
		utils.spawnCallbacks(lifecycleDestroying, self)
		table.clear(self.callbacks)
		isDestroyed = true
	end

	local methodLifecycles = Lifecycles.methodLifecycles[method]
	if not methodLifecycles then
		local newMethodLifecycles = {}
		Lifecycles.methodLifecycles[method] = newMethodLifecycles
		methodLifecycles = newMethodLifecycles
	end

	table.insert(methodLifecycles, self)
	table.freeze(self)
	return self
end

--[=[
  Spawns all callbacks of a lifecycle asynchronously.
  @since 0.2
  @param lifecycle Lifecycle<Args...> -- Lifecycle to spawn callbacks with.
  @param ... Args... -- Arguments to call the callbacks with.
]=]
function Lifecycles.fireConcurrent<Args...>(lifecycle: Lifecycle<Args...>, ...: Args...)
	utils.spawnCallbacks(lifecycle.callbacks, ...)
end

--[=[
  Calls all callbacks of a lifecycle sequentially.
  @since 0.2
  @param lifecycle Lifecycle<Args...> -- Lifecycle to call callbacks with.
  @param ... Args... -- Arguments to call the callbacks with.
]=]
function Lifecycles.fireSequential<Args...>(lifecycle: Lifecycle<Args...>, ...: Args...)
	for _, callback in ipairs(lifecycle.callbacks) do
		callback(...)
	end
end

--[=[
  Called when an object registers a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
  @since 0.2
  @param listener (lifecycle: Lifecycle<Args...>, callback: (Args...) -> () -- Called when any lifecycle registers a callback.
  @return () -> () -- A callback that when called removes the listener.
]=]
function Lifecycles.onRegistered<Args...>(listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()): () -> ()
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleRegistered, listener)
	end

	table.insert(lifecycleRegistered, listener)

	return function()
		findAndRemove(lifecycleRegistered, listener)
	end
end

--[=[
  Called when an object unregisters a lifecycle method. Listeners are expected to be infallible and non-yielding. The listener receives the callback.
  @since 0.2
  @param listener (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> () -- Called when any lifecycle unregisters a callback.
  @return () -> () -- A callback that when called removes the listener.
]=]
function Lifecycles.onUnregistered<Args...>(listener: (lifecycle: Lifecycle<Args...>, callback: (Args...) -> ()) -> ()): () -> ()
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleUnregistered, listener)
	end

	table.insert(lifecycleUnregistered, listener)

	return function()
		findAndRemove(lifecycleUnregistered, listener)
	end
end

--[=[
  Called when a lifecycle is being destroyed. Listeners are expected to be infallible and non-yielding. The listener receives the lifecycle.
  @since 0.2
  @param listener (destroyedLifecycle: Lifecycle<Args...>) -> () -- Called when any lifecycle is being destroyed.
  @return () -> () -- A callback that when called removes the listener.
]=]
function Lifecycles.onLifecycleDestroying<Args...>(listener: (destroyedLifecycle: Lifecycle<Args...>) -> ()): () -> ()
	if DISALLOW_MULTIPLE_LISTENERS then
		findAndRemove(lifecycleDestroying, listener)
	end

	table.insert(lifecycleDestroying, listener)

	return function()
		findAndRemove(lifecycleDestroying, listener)
	end
end

return Lifecycles
