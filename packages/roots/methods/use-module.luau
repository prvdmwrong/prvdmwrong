local providerUsed = require("../hooks/provider-used").callbacks
local providers = require("../../providers")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool
local providerClasses = providers._.providerClasses

local function useModule(root: types.Self, module: ModuleScript)
	local moduleExport = (require)(module)

	if providerClasses[moduleExport] then
		root._rootProviders[moduleExport] = true
		if typeof(moduleExport.name) ~= "string" then
			moduleExport.name = module.Name
		end
		threadpool.spawnCallbacks(providerUsed, root, moduleExport)
	end

	return root
end

return useModule
