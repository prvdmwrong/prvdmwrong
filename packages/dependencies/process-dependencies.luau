local lifecycles = require("../lifecycles")
local types = require("./types")

export type ProccessDependencyResult = {
	sortedDependencies: { types.Dependency<any> },
	lifecycles: { lifecycles.Lifecycle },
}

type Set<T> = { [T]: true }

local function processDependencies(dependencies: Set<types.Dependency<any>>): ProccessDependencyResult
	local sortedDependencies = {}
	local lifecycles = {}

	-- TODO: optimize ts
	local function visitDependency(dependency: types.Dependency<any>)
		-- print("Visiting dependency", dependency)

		for key, value in dependency :: any do
			if key == "dependencies" then
				-- print("Checking [prvd.dependencies]")
				if typeof(value) == "table" then
					for key, value in value do
						-- print("Checking key", key, "value", value)
						if typeof(value) == "table" and value.type == "UnresolvedDependency" then
							local unresolved: types.UnresolvedDependency = value
							-- print("Got unresolved dependency", unresolved.dependency, "visiting")
							visitDependency(unresolved.dependency)
						end
					end
				end

				continue
			end

			if typeof(value) == "table" and value.type == "Lifecycle" and not table.find(lifecycles, value) then
				table.insert(lifecycles, value)
			end
		end

		if dependencies[dependency] and not table.find(sortedDependencies, dependency) then
			-- print("Pushing to sort")
			table.insert(sortedDependencies, dependency)
		end
	end

	for dependency in dependencies do
		visitDependency(dependency)
	end

	return {
		sortedDependencies = sortedDependencies,
		lifecycles = lifecycles,
	}
end

return processDependencies
