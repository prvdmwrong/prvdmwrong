local depend = require("@self/depend")
local processDependencies = require("@self/process-dependencies")
local sortByPriority = require("@self/sort-by-priority")
local types = require("@self/types")

export type Dependency<Self, Dependencies = nil, NewArgs... = ()> = types.Dependency<Self, Dependencies, NewArgs...>

return table.freeze({
	depend = depend,
	processDependencies = processDependencies,
	sortByPriority = sortByPriority,
})
