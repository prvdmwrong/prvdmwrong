local create = require("@self/create")
local fireConcurrent = require("@self/handlers/fire-concurrent")
local fireSequential = require("@self/handlers/fire-sequential")
local lifecycleConstructed = require("@self/hooks/lifecycle-constructed")
local lifecycleDestroyed = require("@self/hooks/lifecycle-destroyed")
local lifecycleRegistered = require("@self/hooks/lifecycle-registered")
local lifecycleUnregistered = require("@self/hooks/lifecycle-unregistered")
local methodToLifecycles = require("@self/method-to-lifecycles")
local types = require("@self/types")

export type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>

return table.freeze({
	create = create,
	handlers = table.freeze({
		fireConcurrent = fireConcurrent,
		fireSequential = fireSequential,
	}),
	hooks = table.freeze({
		onLifecycleRegistered = lifecycleRegistered.onLifecycleRegistered,
		onLifecycleUnregistered = lifecycleUnregistered.onLifecycleUnregistered,
		onLifecycleConstructed = lifecycleConstructed.onLifecycleConstructed,
		onLifecycleDestroyed = lifecycleDestroyed.onLifecycleDestroyed,
	}),
	_ = table.freeze({
		methodToLifecycles = methodToLifecycles,
	}),
})
