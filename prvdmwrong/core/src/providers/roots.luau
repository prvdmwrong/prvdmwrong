local dependencies = require("@core/providers/dependencies")
local lifecycles = require("@core/lifecycles")
local providers = require("@core/providers/providers")
local types = require("@core/types")

type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>
type LuauSolverIssue = any
type Provider<Self> = types.Provider<Self>
type Root = types.Root
type Set<T> = { [T]: true }

local roots = {}
roots.RootStatus = table.freeze {
	Pending = "RootStatus.Pending" :: "RootStatus.Pending",
	Starting = "RootStatus.Starting" :: "RootStatus.Starting",
	Started = "RootStatus.Started" :: "RootStatus.Started",
}

local function useModule(root: Root, module: ModuleScript)
	local moduleExport = require(module) :: any
	if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
		moduleExport.name = _G.PRVDMWRONG_DEV and module:GetFullName() or module.Name
		root.rootProviders[moduleExport] = true
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
			root.rootProviders[moduleExport] = true
		end
	end

	return root
end

local function useProvider(root: Root, provider: Provider<unknown>)
	root.rootProviders[provider] = true
	return root
end

local function useProviders(root: Root, providers: { Provider<unknown> })
	for _, provider in providers do
		root.rootProviders[provider] = true
	end
	return root
end

-- NOTE(znotfireman): Listen to https://www.youtube.com/watch?v=5GcPA3C0QeI
-- when I work on this
local function start(root: Root)
	local processed = dependencies.processProviders(root.rootProviders)
end

--[=[
    @within Prvd
    Construct and returns a new root. Roots are starting points for Prvd 'M Wrong games where providers can be bootstrapped.

    @return Root -- A newly constructed root.
]=]
function roots.root(): Root
	local rootProviders = {}
	local onInit: Lifecycle<()> = lifecycles.lifecycle("onInit", lifecycles.fireSequential)
	local onStart: Lifecycle<()> = lifecycles.lifecycle("onStart", lifecycles.fireConcurrent)
	local onStop: Lifecycle<()> = lifecycles.lifecycle("onStop", lifecycles.fireConcurrent)

	--[=[
        @class Root

        Mustard on the beat ho
    ]=]
	local self = {
		rootProviders = rootProviders,
		start = start,

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
