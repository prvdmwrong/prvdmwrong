local types = require("@self/../types")

type Implementation<T> = { new: (() -> T)?, implementation: T? }

export type RuntimeName = "roblox" | "luau" | "lune" | "lute" | "seal" | "zune"

local supportedRuntimes = table.freeze({
	roblox = require("@self/roblox"),
	luau = require("@self/luau"),
	lune = require("@self/lune"),
	lute = require("@self/lute"),
	seal = require("@self/seal"),
	zune = require("@self/zune"),
})

local currentRuntime: types.Runtime = nil
do
	for _, runtime in supportedRuntimes :: { [string]: types.Runtime } do
		local isRuntime = runtime.is()
		if isRuntime then
			local currentRuntimePriority = currentRuntime and currentRuntime.priority or 0
			local runtimePriority = runtime.priority or 0
			if currentRuntimePriority <= runtimePriority then
				currentRuntime = runtime
			end
		end
	end
	assert(currentRuntime, "No supported runtime")
end

local currentRuntimeName: RuntimeName = currentRuntime.name :: any

local function notImplemented(functionName: string)
	return function()
		error(`'{functionName}' is not implemented by runtime '{currentRuntimeName}'`, 2)
	end
end

local function implementFunction<T>(label: string, implementations: { [types.Runtime]: Implementation<T>? }): T
	local implementation = implementations[currentRuntime]
	if implementation then
		if implementation.new then
			return implementation.new()
		elseif implementation.implementation then
			return implementation.implementation
		end
	end
	return notImplemented(label) :: any
end

return table.freeze({
	supportedRuntimes = supportedRuntimes,
	currentRuntime = currentRuntime,
	implementFunction = implementFunction,
})
