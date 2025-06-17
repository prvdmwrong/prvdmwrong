local lifecycles = require("../lifecycles")
local types = require("./types")

type Set<T> = { [T]: true }

local function processDependencies(
	dependencies: Set<types.Dependency<unknown>>
): ({ types.Dependency<unknown> }, { lifecycles.Lifecycle })
	local visited: Set<types.Dependency<unknown>> = {}
	local sorted = {}
	local lifecycles = {}

	local function visit(target: any)
		if visited[target] or typeof(target) ~= "table" then
			return
		end

		visited[target] = true

		if typeof(target) == "table" then
			if target.type == "Lifecycle" then
				table.insert(lifecycles, target)
				return
			end

			for key, value in target do
				visit(value)
			end
		end

		if dependencies[target] then
			table.insert(sorted, target)
		end
	end

	for dependency in dependencies do
		visit(dependency)
	end

	return sorted, lifecycles
end

return processDependencies
