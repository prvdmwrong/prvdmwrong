local types = require("../types")

local function useComponents(root: types.RootPrivate, components: { types.Component<any, any, any> })
	return root
end

return useComponents
