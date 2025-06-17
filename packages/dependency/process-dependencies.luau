local lifecycles = require("../lifecycles")
local types = require("./types")

type Set<T> = { [T]: true }

local function processDependencies(
	dependencies: Set<types.Dependency<unknown>>
): ({ types.Dependency<unknown> }, { lifecycles.Lifecycle })
	local visited: Set<types.Dependency<unknown>> = {}
	local sorted = {}
	local lifecycles = {}

	local function visit(encountered: Set<types.Dependency<unknown>>, target: any, key: any, parent: any)
		if encountered[target] or typeof(target) ~= "table" then
			return
		end

		encountered[target] = true

		if dependencies[target] then
			table.insert(sorted, target)
			return
		end

		if typeof(target) == "table" then
			if target.type == "Lifecycle" then
				table.insert(lifecycles, target)
				return
			end

			for key, value in target do
				visit(encountered, value, key, target)
			end
		end
	end

	for dependency in dependencies do
		if not visited[dependency] then
			visited[dependency] = true
			visit({}, dependency, nil, dependency)
			table.insert(sorted, dependency)
		end
	end

	return sorted, lifecycles
end

return processDependencies
