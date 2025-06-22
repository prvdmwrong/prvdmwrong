local create = require("@self/create")
local lifecycleUsed = require("@self/hooks/lifecycle-used")
local providerUsed = require("@self/hooks/provider-used")
local rootConstructing = require("@self/hooks/root-constructing")
local rootDestroyed = require("@self/hooks/root-destroyed")
local rootFinished = require("@self/hooks/root-finished")
local rootStarted = require("@self/hooks/root-started")
local rootUsed = require("@self/hooks/root-used")
local types = require("@self/types")

export type Root = types.Root
export type StartedRoot = types.StartedRoot

local roots = table.freeze({
	create = create,
	hooks = table.freeze({
		onLifecycleUsed = lifecycleUsed.onLifecycleUsed,
		onProviderUsed = providerUsed.onProviderUsed,
		onRootUsed = rootUsed.onRootUsed,

		onRootConstructing = rootConstructing.onRootConstructing,
		onRootStarted = rootStarted.onRootStarted,
		onRootFinished = rootFinished.onRootFinished,
		onRootDestroyed = rootDestroyed.onRootDestroyed,
	}),
})

return roots
