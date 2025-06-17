local providerUsed = require("../hooks/provider-used").callbacks
local providers = require("../../providers")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useProvider(root: types.Self, provider: providers.Provider<unknown>)
	root._rootProviders[provider] = true
	threadpool.spawnCallbacks(providerUsed, root, provider)
	return root
end

return useProvider
