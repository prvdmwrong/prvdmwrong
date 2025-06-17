local Lifecycle = require("@self/lifecycle")
local fireConcurrent = require("@self/handlers/fire-concurrent")
local fireSequential = require("@self/handlers/fire-sequential")
local types = require("@self/types")

export type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>

return table.freeze({
	create = Lifecycle.createLifecycle,
	handlers = table.freeze({
		fireConcurrent = fireConcurrent,
		fireSequential = fireSequential,
	}),
	hooks = table.freeze({
		onLifecycleRegistered = Lifecycle.onLifecycleRegistered,
		onLifecycleUnregistered = Lifecycle.onLifecycleUnregistered,
		onLifecycleConstructing = Lifecycle.onLifecycleConstructing,
		onLifecycleDestroying = Lifecycle.onLifecycleDestroying,
	}),
	_ = table.freeze({
		methodLifecycles = Lifecycle.methodLifecycles,
	}),
})
