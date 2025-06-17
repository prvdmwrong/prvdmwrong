local providerUsed = require("../hooks/provider-used").callbacks
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useModule(root: types.Self, module: ModuleScript)
	local moduleExport = (require)(module)

	-- if providers.constructedProviders[moduleExport] and typeof(moduleExport.name) ~= "string" then
	moduleExport.name = module.Name
	root._rootProviders[moduleExport] = true
	threadpool.spawnCallbacks(providerUsed, root, moduleExport)
	-- end

	return root
end

return useModule
