local dependencies = require("./dependencies")
local lifecycles = require("./lifecycles")
local providers = require("./providers")
local roots = require("./roots")

export type Provider<Self, Dependencies = nil> = providers.Provider<Self, Dependencies>
export type Lifecycle<Args... = ...unknown> = lifecycles.Lifecycle<Args...>
export type Root = roots.Root
export type StartedRoot = roots.StartedRoot

local prvd = table.freeze({
	provider = providers.create,
	root = roots.create,
	depend = dependencies.depend,
	priority = dependencies.priority,
	subdependencies = dependencies.subdependencies,

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

		onLifecycleConstructing = lifecycles.hooks.onLifecycleConstructing,
		onLifecycleDestroying = lifecycles.hooks.onLifecycleDestroying,
		onLifecycleRegistered = lifecycles.hooks.onLifecycleRegistered,
		onLifecycleUnregistered = lifecycles.hooks.onLifecycleUnregistered,
	}),
})

local mt = {}

function mt.__call<Self>(_, provider: Self): providers.Provider<Self>
	return providers.create(provider)
end

table.freeze(mt)
return setmetatable(prvd, mt)
