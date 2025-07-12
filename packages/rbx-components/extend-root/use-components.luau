local types = require("../types")

local function useComponents(root: types.RootPrivate, components: { types.AnyComponent })
	for index = 1, #components do
		table.insert(root._classes, components[index])
	end
	return root
end

return useComponents
