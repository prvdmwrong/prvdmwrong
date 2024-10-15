local Lifecycles = require("@core/lifecycles")
local utils = require("@core/utils")

type LuauSolverIssue = any
type Set<T> = { [T]: true }

--[=[
    @within Prvd
    @interface Provider<Self>

    Provider are objects that *provide* specific functions to a game. Providers
    can use lifecycles by specifying the lifecycle's method. Providers can be
    started using a root, which is a starting point for Prvd 'M Wrong games.

    .loadOrder number? -- Wow
    .name string? -- Wow
    .onInit (self: Provider<Self>) -> ()? -- Wow
    .onStart (self: Provider<Self>) -> ()? -- Wow
    .onStop (self: Provider<Self>) -> ()? -- Wow
]=]
export type Provider<Self> = Self & {
	[ConstructedProvider]: Provider<Self>,

	loadOrder: number?,
	name: string?,

	onInit: (self: Provider<Self>) -> ()?,
	onStart: (self: Provider<Self>) -> ()?,
	onStop: (self: Provider<Self>) -> ()?,
}

--[=[
    @within Prvd
    @interface StartRoot

    .useModule (self: Root, module: ModuleScript) -> Root -- Wow
    Pst. I see dead people.
]=]
export type StartRoot = {
	status: (self: StartRoot) -> RootStatus,
	stop: (self: StartRoot) -> (),
}

export type Root = {
	start: (self: Root) -> StartRoot,

	useModule: (self: Root, module: ModuleScript) -> Root,
	useModules: (self: Root, modules: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> Root,
	useRoot: (self: Root, root: Root) -> Root,
	useRoots: (self: Root, roots: { Root }) -> Root,
	useProvider: (self: Root, provider: Provider<unknown>) -> Root,
	useProviders: (self: Root, providers: { Provider<unknown> }) -> Root,
	useLifecycle: (self: Root, lifecycle: Lifecycles.Lifecycle<...unknown>) -> Root,
	useLifecycles: (self: Root, lifecycles: { Lifecycles.Lifecycle<...unknown> }) -> Root,

	providerInit: Lifecycles.Lifecycle<()>,
	providerStart: Lifecycles.Lifecycle<()>,
	providerStop: Lifecycles.Lifecycle<()>,
}

-- Required so TypeScript class decorators can properly register providers
type ConstructedProvider = { ____phantom__constructedProviderKey: never? }
local CONSTRUCTED_PROVIDER_KEY: ConstructedProvider = newproxy();
(getmetatable(CONSTRUCTED_PROVIDER_KEY :: any) :: any).__tostring = function()
	return "<Prvd 'M Wrong> CONSTRUCTED_PROVIDER_KEY"
end

local registeredProviders: Set<Provider<unknown>> = {}
local providerConstructed: { [{}]: (provider: Provider<unknown>) -> () } = {}
local providers = {}

providers.RootStatus = table.freeze {
	Pending = "RootStatus.Pending" :: "RootStatus.Pending",
	Starting = "RootStatus.Starting" :: "RootStatus.Starting",
	Started = "RootStatus.Started" :: "RootStatus.Started",
}

export type RootStatus = index<typeof(providers.RootStatus), keyof<typeof(providers.RootStatus)>>

-- TODO(znotfireman): Probably can merge visitProvider w processProviders but
-- keep visitChild for less functions
local function visitProvider(
	provider: Provider<unknown>,
	visited: Set<Provider<unknown>>,
	stack: { Provider<unknown> },
	lifecycles: { Lifecycles.Lifecycle<...unknown> }
)
	visited[provider] = true

	local encountered = {}

	local function visitChild(target: unknown, key: unknown, parent: { [unknown]: unknown })
		if encountered[target] or typeof(target) ~= "table" then
			return
		end

		encountered[target] = true
		local target: { [unknown]: unknown } = target :: any

		if target.type == "Lifecycle" then
			table.insert(lifecycles, target)
			return
		end

		if key ~= nil and target ~= provider and registeredProviders[target :: LuauSolverIssue] then
			if not visited[target :: LuauSolverIssue] then
				visitProvider(provider, visited, stack, lifecycles)
			end
			return
		end

		for key, value in target do
			visitChild(value, key, target)
		end
	end

	visitChild(provider, nil, provider :: LuauSolverIssue)
	table.insert(stack, provider)
end

local function processProviders(providers: Set<Provider<unknown>>): {
	sortedProviders: { Provider<unknown> },
	lifecycles: { Lifecycles.Lifecycle<...unknown> },
}
	local visited: Set<Provider<unknown>> = {}
	local sortedProviders: { Provider<unknown> } = {}
	local lifecycles: { Lifecycles.Lifecycle<...unknown> } = {}

	for provider in providers do
		visitProvider(provider, visited, sortedProviders, lifecycles)
	end

	return {
		sortedProviders = sortedProviders,
		lifecycles = lifecycles,
	}
end

--[=[
    Construct and returns a new provider. Providers *provide* specific functionality in a game.

    @within Prvd
    @param provider Self -- The provider and associated properties itself.
    @return Provider<Self> -- A newly constructed provider.
]=]
function providers.prvd<Self>(provider: Self, name: string?): Provider<Self>
	local newProvider: Provider<Self> = provider
	newProvider.name = newProvider.name or name
	newProvider[CONSTRUCTED_PROVIDER_KEY] = newProvider
	registeredProviders[newProvider] = true
	return newProvider
end

--[=[
    Construct and returns a new root. Roots are starting points for Prvd 'M Wrong games where providers can be bootstrapped.

    @within Prvd
    @return Root -- A newly constructed root.
]=]
function providers.root(): Root
	local rootProviders: Set<Provider<unknown>> = {}

	--[=[
        @within Prvd
        @class Root

        Mustard on the beat ho
    ]=]
	local self = {} :: Root

	-- NOTE(znotfireman): create "binder" functions for these with it`self`
	self.providerInit = Lifecycles.lifecycle("onInit", Lifecycles.fireSequential) :: Lifecycles.Lifecycle<()>
	self.providerStart = Lifecycles.lifecycle("onStart", Lifecycles.fireConcurrent) :: Lifecycles.Lifecycle<()>
	self.providerStop = Lifecycles.lifecycle("onStop", Lifecycles.fireConcurrent) :: Lifecycles.Lifecycle<()>

	function self:useModule(module: ModuleScript)
		local moduleExport = require(module) :: any
		if registeredProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
			moduleExport.name = _G.PRVDMWRONG_DEV and module:GetFullName() or module.Name
			rootProviders[moduleExport] = true
		end

		return self
	end

	function self:useModules(modules: { Instance }, predicate: ((ModuleScript) -> boolean)?)
		for _, module in modules do
			if not module:IsA("ModuleScript") or predicate and not predicate(module) then
				continue
			end

			local moduleExport = require(module) :: any
			if registeredProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
				moduleExport.name = module.Name :: LuauSolverIssue
				rootProviders[moduleExport] = true
			end
		end

		return self
	end

	function self:useProvider(provider: Provider<unknown>)
		rootProviders[provider] = true
		return self
	end

	function self:useProviders(providers: { Provider<unknown> })
		for _, provider in providers do
			rootProviders[provider] = true
		end
		return self
	end

	-- NOTE(znotfireman): Listen to https://www.youtube.com/watch?v=5GcPA3C0QeI
	-- when I work on this
	function self:start()
		local processed = processProviders(rootProviders)
	end

	return self
end

function providers.onProviderConstructed(listener: (provider: Provider<unknown>) -> ()): () -> ()
	local identifier = table.freeze({})
	providerConstructed[identifier] = listener

	return function()
		providerConstructed[identifier] = nil :: LuauSolverIssue
	end
end

return providers
