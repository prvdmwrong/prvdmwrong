local destroy = require("./methods/destroy")
local lifecycles = require("../lifecycles")
local rootConstructing = require("./hooks/root-constructing")
local start = require("./methods/start")
local types = require("./types")
local useModule = require("./methods/use-module")
local useModules = require("./methods/use-modules")
local useProvider = require("./methods/use-provider")
local useProviders = require("./methods/use-providers")
local useRoot = require("./methods/use-root")
local useRoots = require("./methods/use-roots")
local willFinish = require("./methods/will-finish")
local willStart = require("./methods/will-start")

local function create(): types.Root
	local self: types.Self = {
		type = "Root",

		start = start,

		useProvider = useProvider,
		useProviders = useProviders,
		useModule = useModule,
		useModules = useModules,
		useRoot = useRoot,
		useRoots = useRoots,
		destroy = destroy,

		willStart = willStart,
		willFinish = willFinish,

		_destroyed = false,
		_rootProviders = {},
		_rootLifecycles = {},
		_subRoots = {},
		_start = lifecycles.create("start", lifecycles.handlers.fireConcurrent),
		_finish = lifecycles.create("destroy", lifecycles.handlers.fireSequential),
	} :: any

	for _, callback in rootConstructing.callbacks do
		callback(self)
	end

	return self
end

return create
