local providerUsed = require("../hooks/provider-used").callbacks
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useModules(root: types.Self, modules: { Instance }, predicate: ((module: ModuleScript) -> boolean)?)
	for _, module in modules do
		if not module:IsA("ModuleScript") or predicate and not predicate(module) then
			continue
		end

		local moduleExport = (require)(module)
		-- if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
		moduleExport.name = module.Name
		moduleExport.instance = module
		root._rootProviders[moduleExport] = true
		threadpool.spawnCallbacks(providerUsed, root, moduleExport)
		-- end
	end

	return root
end

return useModules
