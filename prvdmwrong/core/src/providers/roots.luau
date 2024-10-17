-- FIXME: Luau is WEIRD
local game: DataModel = game
local RunService = game:GetService("RunService")

local dependencies = require("@core/providers/dependencies")
local handlers = require("@core/lifecycles/handlers")
local lifecycles = require("@core/lifecycles/lifecycles")
local log = require("@core/log")
local providers = require("@core/providers/providers")
local types = require("@core/types")
local utils = require("@core/utils")

type Error = types.Error
type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>
type Provider<Self> = types.Provider<Self>
type Root = types.Root
type StartedRoot = types.StartedRoot

type BrokenLuau = any
type Set<T> = { [T]: true }
type Self = Root & {
	_rootProviders: Set<Provider<unknown>>,
	_rootLifecycles: Set<Lifecycle>,
	_subRoots: Set<Root>,
}

local roots = {}
local RootStatus = table.freeze {
	Pending = "RootStatus.Pending" :: "RootStatus.Pending",
	Starting = "RootStatus.Starting" :: "RootStatus.Starting",
	Started = "RootStatus.Started" :: "RootStatus.Started",
	Stopped = "RootStatus.Stopped" :: "RootStatus.Stopped",
}

roots.RootStatus = RootStatus

local providerUsed: { (root: Root, provider: Provider<unknown>) -> () } = {}
local lifecycleUsed: { (root: Root, lifecycle: Lifecycle) -> () } = {}
local subRootUsed: { (root: Root, subRoot: Root) -> () } = {}
local rootConstructed: { (root: Root) -> () } = {}
local rootStarted: { (root: Root, startedRoot: StartedRoot) -> () } = {}

local function loggedRequire(module: ModuleScript): any
	local ok, result: any = xpcall(require, log.parseError, module)
	if ok then
		return result
	end
	return log.fatal("requireError", (result :: Error).trace, module:GetFullName(), (result :: Error).message)
end

--[=[
    @within Root

    Requires a ModuleScript and adds the returned provider to the root, if any.
    If the provider is unnamed, the provider is named after the ModuleScript
    name.

    @param root Root -- The root that should use the ModuleScript.
    @param module ModuleScript -- The ModuleScript that should be required.
    @return Root -- The same root for convenience.
]=]
local function useModule(root: Self, module: ModuleScript)
	local moduleExport = loggedRequire(module)

	if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" :: BrokenLuau then
		moduleExport.name = module.Name
		moduleExport.instance = module
		root._rootProviders[moduleExport] = true
		utils.spawnCallbacks(providerUsed, root, moduleExport)
	end

	return root
end

--[=[
    @within Root

    Given an array of instances, requires all ModuleScripts and adds the
    returned provider to the root, if any. If the provider is unnamed, the
    provider is named after the ModuleScript name. An optional predicate
    function can be provided to filter the modules.

    @param root Root -- The root that should use the ModuleScripts.
    @param modules { Instance } -- The given instances to require.
    @param predicate ((module: ModuleScript) -> boolean)? -- An optional predicate function to filter the given modules.
    @return Root -- The same root for convenience.
]=]
local function useModules(root: Self, modules: { Instance }, predicate: ((module: ModuleScript) -> boolean)?)
	for _, module in modules do
		if not module:IsA("ModuleScript") or predicate and not predicate(module) then
			continue
		end

		local moduleExport = loggedRequire(module)
		if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" :: BrokenLuau then
			moduleExport.name = module.Name
			moduleExport.instance = module
			root._rootProviders[moduleExport] = true
			utils.spawnCallbacks(providerUsed, root, moduleExport)
		end
	end

	return root
end

--[=[
    @within Root

    Uses the given "sub" root to be started when the "parent" root is started.

    @param root Root -- The "parent" root that should use the root.
    @param subRoot Root -- The "sub" root that should be queued.
    @return Root -- The same "parent" root for convenience.
]=]
local function useRoot(root: Self, subRoot: Root)
	root._subRoots[subRoot] = true
	utils.spawnCallbacks(subRootUsed, root, subRoot)
	return root
end

--[=[
    @within Root

    Given an array of "sub" roots, uses all roots to be started when the
    "parent" root is started.

    @param root Root -- The "parent" root that should use the root.
    @param subRoots { Root } -- The "sub" roots that should be queued.
    @return Root -- The same "parent" root for convenience.
]=]
local function useRoots(root: Self, subRoots: { Root })
	for _, subRoot in subRoots do
		root._subRoots[subRoot] = true
		utils.spawnCallbacks(subRootUsed, root, subRoot)
	end
	return root
end

--[=[
    @within Root

    Uses the provider to be initialized when the root starts. When the root is
    started, used providers are resolved in topological loading order while
    lifecycles in the providers are added as dependencies to be registered.

    @param root Root -- The root that should use the provider.
    @param provider Provider<unknown> -- The provider to be providers.
    @return Root -- The same root for convenience.
]=]
local function useProvider(root: Self, provider: Provider<unknown>)
	root._rootProviders[provider] = true
	utils.spawnCallbacks(providerUsed, root, provider)
	return root
end

--[=[
    @within Root

    Given an array of providers, uses all providers to the root. When the root is
    started, used providers are resolved in topological loading order while
    lifecycles in providers are added as dependencies to be registered.

    @param root Root -- The root that should use the providers.
    @param providers { Provider<unknown> } -- The providers to be added.
    @return Root -- The same root for convenience.
]=]
local function useProviders(root: Self, providers: { Provider<unknown> })
	for _, provider in providers do
		root._rootProviders[provider] = true
		utils.spawnCallbacks(providerUsed, root, provider)
	end
	return root
end

--[=[
    @within Root

    Uses the lifecycle as a dependency. When the root is started, all providers
    with the lifecycle's method will have it registered.

    @param root Root -- The root that should use the lifecycle.
    @param lifecycle Lifecycle -- The lifecycle to be used.
    @return Root -- The same root for convenience.
]=]
local function useLifecycle(root: Self, lifecycle: Lifecycle)
	root._rootLifecycles[lifecycle] = true
	utils.spawnCallbacks(lifecycleUsed, root, lifecycle)
	return root
end

--[=[
    @within Root

    Given an array of lifecycles, uses all lifecycles as dependencies. When the
    root is started, all providers with each lifecycle's method will have it
    registered.

    @param root Root -- The root that should use the lifecycles.
    @param lifecycles { Lifecycle } -- The lifecycles to be used.
    @return Root -- The same root for convenience.
]=]
local function useLifecycles(root: Self, lifecycles: { Lifecycle })
	for _, lifecycle in lifecycles do
		root._rootLifecycles[lifecycle] = true
		utils.spawnCallbacks(lifecycleUsed, root, lifecycle)
	end
	return root
end

--[=[
    @within Root
]=]
local function destroy(root: Self)
	error("not implemented")
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
				debug.profileend()
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

--[=[
    @within Root

    Starts the root. This should only be called once per root.

    @param root Root -- The root to start.
    @return StartedRoot -- A root that has been started.
]=]
local function start(root: Self): StartedRoot
	utils.assert(root.status == RootStatus.Pending or root.status == RootStatus.Stopped, "alreadyStarted")
	root.status = RootStatus.Starting

	local processed = dependencies.processProviders(root._rootProviders)
	local lifecycles = processed.lifecycles
	local sortedProviders = processed.sortedProviders

	for lifecycle in root._rootLifecycles do
		table.insert(sortedProviders, lifecycle)
	end

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
		-- TODO: add onInitError here
		bindLifecycle("onInit", provider, root.onInit, nameOf(provider, "onInit"))
		bindLifecycle("onStart", provider, root.onStart, nameOf(provider, "onStart"))
		bindLifecycle("onStop", provider, root.onStop, nameOf(provider, "onStop"))

		-- NOTE(znotfireman): I have a gut feeling this will backfire HARD
		for _, lifecycle in lifecycles do
			bindLifecycle(lifecycle.method, provider, lifecycle, nameOf(provider, lifecycle.method), lifecycleCallbacks)
		end
	end

	root.onInit:fire()

	local subRoots: { StartedRoot } = {}
	for root in root._subRoots do
		table.insert(subRoots, root:start())
	end

	root.onStart:fire()
	root.status = RootStatus.Started

	--[=[
        @class StartedRoot

        Pst. I see dead people.
    ]=]
	local startedRoot = {} :: StartedRoot

	--[=[
        @within StartedRoot

        Fein', fein', fein', fein'-fein' (yeah)
        Fein', fein', fein', fein'-fein' (yeah)
        Fein', fein', fein', fein'-fein'
        Fein', fein', fein', fein' (yeah)

        @param startedRoot StartedRoot -- The root to stop.
    ]=]
	function startedRoot.stop(startedRoot: StartedRoot)
		utils.assert(root.status ~= RootStatus.Stopped, "alreadyStopped")
		root.onStop:fire()
		root.status = RootStatus.Stopped

		-- NOTE(znotfireman): Assume the user cleans up their own lifecycles
		root.onInit:unregisterAll()
		root.onStart:unregisterAll()
		root.onStop:unregisterAll()

		for _, subRoot in subRoots do
			subRoot:stop()
		end
	end

	for _, onRootStarted in rootStarted do
		onRootStarted(root, startedRoot)
	end

	return startedRoot
end

--[=[
    @within Prvd

    Construct and returns a new root. Roots are starting points for Prvd 'M
    Wrong games where providers can be bootstrapped.

    @return Root -- A newly constructed root.
]=]
function roots.root(): Root
	--[=[
        @class Root

        Roots are entry points to Prvd 'M Wrong games. Use roots to include
        providers to be started, modules to be required, lifecycles to be
        registered, and even "sub" roots to be started. Call `start` to
        bootstrap the root. Later, call `stop` to clean up the root.

        ```Luau
        local function filterByPattern(pattern: string)
            return function(module: ModuleScript): boolean
                return module:find(pattern) ~= nil
            end
        end

        -- roots are entry points for Prvd 'M Wrong games!
        local root = prvd.root()
            :useModules(script.Providers:GetDescendants(), filterByPattern("Provider$"))
            :useModules(ReplicatedStorage.Providers:GetDescendants(), filterByPattern("Provider$"))
            :useProvider(prvdLifecycles)
            :useRoot(prvd.netRoot)
            :useRoot(prvd.componentRoot)
            :start()

        -- later...
        game:BindToClose(function()
            root:stop()
        end)
        ```
    ]=]
	local self = {
		type = "Root",

		_rootProviders = {},
		_rootLifecycles = {},
		_subRoots = {},

		start = start,

		--[=[
    	    @within Root
    	    @prop status RootStatus

    		The current status of the root:

            - `RootStatus.Pending` indicates the root has not been started yet.
            - `RootStatus.Starting` indicates the root is being started.
            - `RootStatus.Started` indicates the root has finished starting up.
            - `RootStatus.Stopped` indicates the root has been stopped.
    	]=]
		status = RootStatus.Pending,

		useModule = useModule,
		useModules = useModules,
		useRoot = useRoot,
		useRoots = useRoots,
		useProvider = useProvider,
		useProviders = useProviders,
		useLifecycle = useLifecycle,
		useLifecycles = useLifecycles,
		destroy = destroy,

		--[=[
		    @within Root
		    @prop onInit Lifecycle<()>

			The root's associated `onInit` lifecycle used for provider
			initialization. All providers with an `onInit` method have it called
			sequentially. Dependencies have `onInit` called earlier.
		]=]
		onInit = lifecycles.lifecycle("onInit", handlers.fireSequential) :: Lifecycle<()>,

		--[=[
		    @within Root
		    @prop onStart Lifecycle<()>

			The root's associated `onStart` lifecycle used for background tasks.
			All providers with an `onStart` method have it spawned in a new
			thread.
		]=]
		onStart = lifecycles.lifecycle("onStart", handlers.fireConcurrent) :: Lifecycle<()>,

		--[=[
		    @within Root
		    @prop onStop Lifecycle<()>

			The root's associated `onStop` lifecycle used for destruction tasks.
			All providers with an `onStop` method have it spawned when the root
			is stopped.
		]=]
		onStop = lifecycles.lifecycle("onStop", handlers.fireConcurrent) :: Lifecycle<()>,
	} :: Self

	for _, onConstructedRoot in rootConstructed do
		onConstructedRoot(self)
	end

	return self
end

--[=[
    @within Prvd

    Called when a root uses a provider. The listener callback receives the root
    along with the used provider

    @param listener (root: Root, provider: Provider<unknown>) -> () -- Fired when a root uses a provider. The listener callback receives the root along with the used provider
    @return () -> () -- A callback that when called removes the listener.
]=]
function roots.onProviderUsed(listener: (root: Root, provider: Provider<unknown>) -> ()): () -> ()
	table.insert(providerUsed, listener)

	return function()
		utils.findAndRemove(providerUsed, listener)
	end
end

--[=[
    @within Prvd

    Called when a "parent" root uses a "sub" root. The listener callback
    receives the root along with the used provider

    @param listener (root: Root, subRoot: Root) -> () -- Fired when a root uses a "sub" root. The listener callback receives the "parent" root along with the used "sub" root
    @return () -> () -- A callback that when called removes the listener.
]=]
function roots.onSubRootUsed(listener: (root: Root, subRoot: Root) -> ()): () -> ()
	table.insert(subRootUsed, listener)

	return function()
		utils.findAndRemove(subRootUsed, listener)
	end
end

--[=[
    @within Prvd

    Called when a root uses a lifecycle. The listener callback receives the root
    along with the used lifecycle

    @param listener (root: Root, lifecycle: Lifecycle) -> () -- Fired when a root uses a provider. The listener callback receives the root along with the used lifecycle.
    @return () -> () -- A callback that when called removes the listener.
]=]
function roots.onLifecycleUsed(listener: (root: Root, lifecycle: Lifecycle) -> ()): () -> ()
	table.insert(lifecycleUsed, listener)

	return function()
		utils.findAndRemove(lifecycleUsed, listener)
	end
end

--[=[
    @within Root

    Called just before a constructing root is returned. The listener callback
    receives the root that is constructing.

    Listener callbacks are expected to be non-yielding and infallible.

    @param listener (root: Root) -> () -- Fired just before a constructing root is returned. The listener callback receives the root that is constructing.
    @return () -> () -- A callback that when called removes the listener.
]=]
function roots.onRootConstructed(listener: (root: Root) -> ()): () -> ()
	table.insert(rootConstructed, listener)

	return function()
		utils.findAndRemove(rootStarted, listener)
	end
end

--[=[
    @within Root

    Called just before a root finishes starting. The listener callback receives
    the root that is starting.

    Listener callbacks are expected to be non-yielding and infallible.

    @param listener (root: Root) -> () -- Fired just before a root finishes starting. The listener callback receives the root that is starting.
    @return () -> () -- A callback that when called removes the listener.
]=]
function roots.onRootStarted(listener: (root: Root, startedRoot: Root) -> ()): () -> ()
	table.insert(rootStarted, listener)

	return function()
		utils.findAndRemove(rootStarted, listener)
	end
end

return roots
