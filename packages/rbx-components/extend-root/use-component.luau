local types = require("../types")

local function useComponent(root: types.RootPrivate, component: types.Component<any, any, any>)
	return root
end

return useComponent
