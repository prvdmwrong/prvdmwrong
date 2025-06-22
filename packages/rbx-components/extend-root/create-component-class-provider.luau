local ComponentProvider = require("../component-provider")
local providers = require("../../providers")
local types = require("../types")

local ComponentClassProvider = {}
ComponentClassProvider.priority = -math.huge
ComponentClassProvider.name = "@rbx-components.ComponentClassProvider"
ComponentClassProvider.subdependencies = table.freeze({
	componentProvider = ComponentProvider,
})

ComponentClassProvider._components = {} :: { types.Component<any, any, any> }

function ComponentClassProvider.constructor(
	self: ComponentClassProvider,
	dependencies: typeof(ComponentClassProvider.subdependencies)
)
	for _, class in self._components do
		dependencies.componentProvider:addComponentClass(class)
	end
end

export type ComponentClassProvider = typeof(ComponentClassProvider)

local function createComponentClassProvider(components: { types.Component<any, any, any> })
	local provider = table.clone(ComponentClassProvider)
	provider._components = components
	return providers.create(provider)
end

return createComponentClassProvider
