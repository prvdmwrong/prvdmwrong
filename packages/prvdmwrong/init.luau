local dependencies = require("./dependencies")
local lifecycles = require("./lifecycles")
local providers = require("./providers")
local roots = require("./roots")

export type Provider<Self, Dependencies = nil> = providers.Provider<Self, Dependencies>
export type Lifecycle<Args... = ...unknown> = lifecycles.Lifecycle<Args...>
export type Root = roots.Root
export type StartedRoot = roots.StartedRoot

local prvd = {
	provider = providers.create,
	root = roots.create,
	depend = dependencies.depend,
	nameOf = providers.nameOf,

	lifecycle = lifecycles.create,
	fireConcurrent = lifecycles.handlers.fireConcurrent,
	fireSequential = lifecycles.handlers.fireSequential,

	hooks = table.freeze({
		onProviderUsed = roots.hooks.onProviderUsed,
		onLifecycleUsed = roots.hooks.onLifecycleUsed,
		onRootConstructing = roots.hooks.onRootConstructing,
		onRootUsed = roots.hooks.onRootUsed,
		onRootStarted = roots.hooks.onRootStarted,
		onRootFinished = roots.hooks.onRootFinished,
		onRootDestroyed = roots.hooks.onRootDestroyed,

		onLifecycleConstructed = lifecycles.hooks.onLifecycleConstructed,
		onLifecycleDestroyed = lifecycles.hooks.onLifecycleDestroyed,
		onLifecycleRegistered = lifecycles.hooks.onLifecycleRegistered,
		onLifecycleUnregistered = lifecycles.hooks.onLifecycleUnregistered,
	}),
}

local mt = {}

function mt.__call<Self>(_, provider: Self): providers.Provider<Self, any>
	return providers.create(provider) :: any
end

table.freeze(mt)
return setmetatable(table.freeze(prvd), mt)
