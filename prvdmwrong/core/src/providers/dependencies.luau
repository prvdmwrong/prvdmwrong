local providers = require("@core/providers/providers")
local types = require("@core/types")

type Lifecycle<Args... = ...unknown> = types.Lifecycle<Args...>
type LuauSolverIssue = any
type Provider<Self> = types.Provider<Self>
type Set<T> = { [T]: true }

local dependencies = {}

-- TODO(znotfireman): Probably can merge visitProvider w processProviders but
-- keep visitChild for less functions
-- TODO(znotfireman): Maybe add a second pass for also delegating lifecycles too?
local function visitProvider(
	provider: types.Provider<unknown>,
	visited: Set<Provider<unknown>>,
	stack: { Provider<unknown> },
	lifecycles: { Lifecycle }
)
	if visited[provider] then
		return
	end
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

		if key ~= nil and target ~= provider and providers.constructedProviders[target :: LuauSolverIssue] then
			if not visited[target :: LuauSolverIssue] then
				visitProvider(target :: LuauSolverIssue, visited, stack, lifecycles)
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

function dependencies.processProviders(providers: Set<Provider<unknown>>): {
	sortedProviders: { Provider<unknown> },
	lifecycles: { Lifecycle },
}
	local visited: Set<Provider<unknown>> = {}
	local sortedProviders: { Provider<unknown> } = {}
	local lifecycles: { Lifecycle } = {}

	for provider in providers do
		visitProvider(provider, visited, sortedProviders, lifecycles)
	end

	return {
		sortedProviders = sortedProviders,
		lifecycles = lifecycles,
	}
end

return dependencies
