local componentClasses = require("../component-classes")
local types = require("../types")

local function useModuleAsComponent(root: types.RootPrivate, module: ModuleScript)
	local required = (require)(module)
	if componentClasses[required] then
		table.insert(root, required)
	end
	return root
end

return useModuleAsComponent
