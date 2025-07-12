local types = require("../types")

local function useComponent(root: types.RootPrivate, component: types.AnyComponent)
	table.insert(root._classes, component)
	return root
end

return useComponent
