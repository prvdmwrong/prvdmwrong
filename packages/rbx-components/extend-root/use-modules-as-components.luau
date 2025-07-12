local componentClasses = require("../component-classes")
local types = require("../types")

local function useModulesAsComponents(
	root: types.RootPrivate,
	modules: { Instance },
	predicate: ((ModuleScript) -> boolean)?
)
	for index = 1, #modules do
		local module = modules[index]

		if not module:IsA("ModuleScript") then
			continue
		end

		if predicate and not predicate(module) then
			continue
		end

		local required = (require)(module)
		if componentClasses[required] then
			table.insert(root, required)
		end
	end
	return root
end

return useModulesAsComponents
