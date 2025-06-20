local types = require("../types")

local function useModulesAsComponents(
	root: types.RootPrivate,
	modules: { Instance },
	predicate: ((ModuleScript) -> boolean)?
)
	return root
end

return useModulesAsComponents
