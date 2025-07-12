local dependencies = require("../../dependencies")
local lifecycles = require("../../lifecycles")
local logger = require("../logger")
local providers = require("../../providers")
local rootFinished = require("../hooks/root-finished").callbacks
local rootStarted = require("../hooks/root-started").callbacks
local types = require("../types")

local function bindLifecycle(
	method: string,
	provider: providers.Provider<any>,
	lifecycle: lifecycles.Lifecycle<...any>,
	memoryCategory: string
)
	local lifecycleMethod = (provider :: any)[method]
	if typeof(lifecycleMethod) == "function" then
		local isProfiling = _G.PRVDMWRONG_PROFILE_LIFECYCLES

		if isProfiling then
			lifecycle:register(function(...)
				debug.profilebegin(memoryCategory)
				debug.setmemorycategory(memoryCategory)
				lifecycleMethod(provider, ...)
				debug.resetmemorycategory()
				debug.profileend()
			end)
		else
			lifecycle:register(function(...)
				lifecycleMethod(provider, ...)
			end)
		end
	end
end

local function nameOf(provider: providers.Provider<unknown>, extension: string?): string
	return if extension then `{tostring(provider)}.{extension}` else tostring(provider)
end

local function start(root: types.Self): types.StartedRoot
	local processed = dependencies.processDependencies(root._rootProviders)
	local sortedProviders = processed.sortedDependencies :: { providers.Provider<any> }
	local lifecycles = processed.lifecycles
	table.move(root._rootLifecycles, 1, #root._rootLifecycles, #lifecycles + 1, lifecycles)

	dependencies.sortByPriority(sortedProviders)

	local constructedProviders = {}
	for _, provider in sortedProviders do
		local providerDependencies = (provider :: any).dependencies
		if typeof(providerDependencies) == "table" then
			providerDependencies = table.clone(providerDependencies)
			for key, value in providerDependencies do
				providerDependencies[key] = constructedProviders[value]
			end
		end

		local constructed = provider.new(providerDependencies)
		constructedProviders[provider] = constructed
		bindLifecycle("start", constructed, constructed.start, nameOf(constructed, "start"))
		bindLifecycle("finish", constructed, constructed.finish, nameOf(constructed, "finish"))
	end

	local subRoots: { types.StartedRoot } = {}
	for root in root._subRoots do
		table.insert(subRoots, root:start())
	end

	root._start:fire()

	local startedRoot = {} :: types.StartedRoot
	startedRoot.type = "StartedRoot"

	local didFinish = false

	function startedRoot:finish()
		if didFinish then
			return logger:fatalError({ template = logger.alreadyFinished })
		end

		didFinish = true
		root._finish:fire()

		-- NOTE(znotfireman): Assume the user cleans up their own lifecycles
		root._start:clear()
		root._finish:clear()

		for _, subRoot in subRoots do
			subRoot:finish()
		end

		for _, hook in rootFinished do
			hook(root)
		end
	end

	for _, hook in rootStarted do
		hook(root)
	end

	return startedRoot
end

return start
