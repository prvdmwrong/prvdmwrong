local providerUsed = require("../hooks/provider-used").callbacks
local providers = require("../../providers")
local runtime = require("../../runtime")
local types = require("../types")

local threadpool = runtime.threadpool

local function useProviders(root: types.Self, providers: { providers.Provider<unknown> })
	for _, provider in providers do
		root._rootProviders[provider] = true
		threadpool.spawnCallbacks(providerUsed, root, provider)
	end
	return root
end

return useProviders
