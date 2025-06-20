local ComponentProvider = require("./component-provider")
local createComponentClassProvider = require("@self/create-component-class-provider")
local logger = require("./logger")
local roots = require("../roots")
local types = require("./types")
local useComponent = require("@self/use-component")
local useComponents = require("@self/use-components")
local useModuleAsComponent = require("@self/use-module-as-component")
local useModulesAsComponents = require("@self/use-modules-as-components")

local function extendRoot(root: types.RootPrivate): types.Root
	if root._hasComponentExtensions then
		return logger:fatalError({ template = logger.rootAlreadyExtended })
	end

	root._hasComponentExtensions = true
	root._classes = {}

	root:useProvider(ComponentProvider)
	root:useProvider(createComponentClassProvider(root._classes))

	root.useComponent = useComponent :: any
	root.useComponents = useComponents :: any
	root.useModuleAsComponent = useModuleAsComponent :: any
	root.useModulesAsComponents = useModulesAsComponents :: any

	return root
end

return extendRoot :: (root: roots.Root) -> types.Root
