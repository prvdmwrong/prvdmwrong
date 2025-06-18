local dependencies = require("../../dependencies")
local lifecycles = require("../../lifecycles")
local logger = require("../logger")
local providers = require("../../providers")
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
	if extension then
		return `{provider.name or "unnamedProvider"}:{extension}`
	else
		return provider.name or "unnamedProvider"
	end
end

local function start(root: types.Self): types.StartedRoot
	local sortedProviders, lifecycles = dependencies.processDependencies(root._rootProviders)
	table.move(root._rootLifecycles, 1, #root._rootLifecycles, #lifecycles + 1, lifecycles)

	dependencies.sortDependencies(sortedProviders)
	for _, provider in (sortedProviders :: any) :: { providers.Provider<any> } do
		local constructed = provider.new()
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
		root._start:unregisterAll()
		root._finish:unregisterAll()

		for _, subRoot in subRoots do
			subRoot:finish()
		end
	end

	return startedRoot
end

return start
