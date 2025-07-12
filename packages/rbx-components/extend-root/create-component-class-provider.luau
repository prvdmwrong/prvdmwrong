local ComponentProvider = require("../component-provider")
local providers = require("../../providers")
local types = require("../types")

local ComponentClassProvider = {}
ComponentClassProvider.priority = -math.huge
ComponentClassProvider.name = "@rbx-components.ComponentClassProvider"
ComponentClassProvider.dependencies = table.freeze({
	componentProvider = ComponentProvider,
})

ComponentClassProvider._components = {} :: { types.AnyComponent }

function ComponentClassProvider.constructor(
	self: ComponentClassProvider,
	dependencies: typeof(ComponentClassProvider.dependencies)
)
	for _, class in self._components do
		dependencies.componentProvider:addComponentClass(class)
	end
end

export type ComponentClassProvider = typeof(ComponentClassProvider)

local function createComponentClassProvider(components: { types.AnyComponent })
	local provider = table.clone(ComponentClassProvider)
	provider._components = components
	return providers.create(provider)
end

return createComponentClassProvider
