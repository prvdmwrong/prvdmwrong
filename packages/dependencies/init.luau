local depend = require("@self/depend")
local processDependencies = require("@self/process-dependencies")
local sortByPriority = require("@self/sort-by-priority")
local subdependencies = require("@self/subdependencies")
local types = require("@self/types")

export type Dependency<Self, Dependencies = nil> = types.Dependency<Self, Dependencies>

return table.freeze({
	depend = depend,
	subdependencies = subdependencies,
	processDependencies = processDependencies,
	sortByPriority = sortByPriority,
})
