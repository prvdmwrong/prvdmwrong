-- FIXME: Luau is WEIRD
local game: DataModel = game
local RunService = game:GetService("RunService")

local dependencies = require("@core/providers/dependencies")
local lifecycles = require("@core/lifecycles")
local providers = require("@core/providers/providers")
local types = require("@core/types")
local utils = require("@core/utils")

type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>
type LuauSolverIssue = any
type Provider<Self> = types.Provider<Self>
type Root = types.Root
type Set<T> = { [T]: true }
type StartedRoot = types.StartedRoot

local roots = {}
local RootStatus = table.freeze {
	Pending = "RootStatus.Pending" :: "RootStatus.Pending",
	Starting = "RootStatus.Starting" :: "RootStatus.Starting",
	Started = "RootStatus.Started" :: "RootStatus.Started",
	Stopped = "RootStatus.Stopped" :: "RootStatus.Stopped",
}

roots.RootStatus = RootStatus

local function useModule(root: Root, module: ModuleScript)
	local moduleExport = require(module) :: any
	if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
		moduleExport.name = _G.PRVDMWRONG_DEV and module:GetFullName() or module.Name
		root._rootProviders[moduleExport] = true
	end

	return root
end

local function useModules(root: Root, modules: { Instance }, predicate: ((ModuleScript) -> boolean)?)
	for _, module in modules do
		if not module:IsA("ModuleScript") or predicate and not predicate(module) then
			continue
		end

		local moduleExport = require(module) :: any
		if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
			moduleExport.name = module.Name :: LuauSolverIssue
			root._rootProviders[moduleExport] = true
		end
	end

	return root
end

local function useProvider(root: Root, provider: Provider<unknown>)
	root._rootProviders[provider] = true
	return root
end

local function useProviders(root: Root, providers: { Provider<unknown> })
	for _, provider in providers do
		root._rootProviders[provider] = true
	end
	return root
end

local function nameOf(provider: Provider<unknown>, extension: string?): string
	if extension then
		return `{provider.name or "unnamedProvider"}:{extension}`
	else
		return provider.name or "unnamedProvider"
	end
end

local function bindLifecycle<Args...>(
	method: string,
	provider: Provider<unknown>,
	lifecycle: Lifecycle<Args...>,
	memoryCategory: string
)
	local lifecycleMethod = provider[method]
	if typeof(lifecycleMethod) == "function" then
		local isProfiling = _G.PRVDMWRONG_PROFILE_LIFECYCLES
		if isProfiling == nil then
			isProfiling = RunService:IsStudio()
		end

		if isProfiling then
			lifecycle:register(function(...: Args...)
				debug.profilebegin(memoryCategory)
				debug.setmemorycategory(memoryCategory)
				lifecycleMethod(provider, ...)
				debug.resetmemorycategory()
			end)
		else
			lifecycle:register(function(...: Args...)
				lifecycleMethod(provider, ...)
			end)
		end
	end
end

-- NOTE(znotfireman): Listen to https://www.youtube.com/watch?v=5GcPA3C0QeI
-- when I work on this
-- TODO(znotfireman): Should this be async and basically behave like a promise?
-- TODO(znotfireman): Should we add cancellation here?
-- TODO: subroots
local function start(root: Root): StartedRoot
	utils.assert(root.status == RootStatus.Pending or root.status == RootStatus.Stopped, "cannot start twice")
	root.status = RootStatus.Starting

	local processed = dependencies.processProviders(root._rootProviders)
	local sortedProviders = processed.sortedProviders

	local providers: { Provider<unknown> } = table.clone(sortedProviders)
	table.sort(providers, function(left: Provider<unknown>, right: Provider<unknown>)
		if left.loadOrder ~= right.loadOrder then
			return (left.loadOrder or 1) < (right.loadOrder or 1)
		end
		local leftIndex = assert(table.find(sortedProviders, left), "Unreachable")
		local rightIndex = assert(table.find(sortedProviders, right), "Unreachable")
		return leftIndex < rightIndex
	end)

	local lifecycleCallbacks = {}
	for _, provider in providers do
		bindLifecycle("onInit", provider, root.onInit, nameOf(provider, "onInit"))
		bindLifecycle("onStart", provider, root.onStart, nameOf(provider, "onStart"))
		bindLifecycle("onStop", provider, root.onStop, nameOf(provider, "onStop"))

		-- NOTE(znotfireman): I have a gut feeling this will backfire HARD
		for _, lifecycle in processed.lifecycles do
			bindLifecycle(lifecycle.method, provider, lifecycle, nameOf(provider, lifecycle.method), lifecycleCallbacks)
		end
	end

	root.onInit:fire()
	root.onStart:fire()
	root.status = RootStatus.Started

	local startedRoot = {} :: StartedRoot

	function startedRoot:stop()
		root.onStop:fire()
		root.status = RootStatus.Stopped

		-- NOTE(znotfireman): Assume the user cleans up their own lifecycles
		root.onInit:unregisterAll()
		root.onStart:unregisterAll()
		root.onStop:unregisterAll()
	end

	return startedRoot
end

--[=[
    @within Prvd
    Construct and returns a new root. Roots are starting points for Prvd 'M Wrong games where providers can be bootstrapped.

    @return Root -- A newly constructed root.
]=]
function roots.root(): Root
	local rootProviders = {}
	local subRoots = {}
	local onInit: Lifecycle<()> = lifecycles.lifecycle("onInit", lifecycles.fireSequential)
	local onStart: Lifecycle<()> = lifecycles.lifecycle("onStart", lifecycles.fireConcurrent)
	local onStop: Lifecycle<()> = lifecycles.lifecycle("onStop", lifecycles.fireConcurrent)

	--[=[
        @class Root

        Mustard on the beat ho
    ]=]
	local self = {
		_rootProviders = rootProviders,
		_subRoots = subRoots,

		start = start,
		status = RootStatus.Pending,

		useModule = useModule,
		useModules = useModules,
		useProvider = useProvider,
		useProviders = useProviders,

		-- NOTE(znotfireman): create "binder" functions for these with it`self`
		onInit = onInit,
		onStart = onStart,
		onStop = onStop,
	} :: Root

	return self
end

return roots
