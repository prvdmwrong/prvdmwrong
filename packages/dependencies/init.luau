local processDependencies = require("@self/process-dependencies")
local sortDependencies = require("@self/sort-dependencies")
local types = require("@self/types")

export type Dependency<Self> = types.Dependency<Self>

return table.freeze({
	processDependencies = processDependencies,
	sortDependencies = sortDependencies,
})
