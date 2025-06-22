local logger = require("./logger")
local types = require("./types")

local function useBeforeConstructed(unresolved: types.UnresolvedDependency)
	logger:fatalError({ template = logger.useBeforeConstructed, unresolved.dependency.name or "subdependency" })
end

local unresolvedMt = {
	__metatable = "This metatable is locked.",
	__index = useBeforeConstructed,
	__newindex = useBeforeConstructed,
}

function unresolvedMt:__tostring()
	return "UnresolvedDependency"
end

-- Wtf luau
local function depend<Self, Dependencies, NewArgs...>(dependency: types.Dependency<Self, Dependencies, NewArgs...>): typeof(({} :: types.Dependency<Self, Dependencies, NewArgs...>).new(
	(nil :: any) :: Dependencies,
	...
))
	-- Return a mock value that will be resolved during dependency resolution.
	return setmetatable({
		type = "UnresolvedDependency",
		dependency = dependency,
	}, unresolvedMt) :: any
end

return depend
