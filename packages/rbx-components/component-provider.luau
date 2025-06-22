local providers = require("../providers")
local types = require("./types")

local ComponentProvider = {}
ComponentProvider.priority = -math.huge
ComponentProvider.name = "@rbx-components"

function ComponentProvider.constructor(self: ComponentProvider) end

function ComponentProvider.start(self: ComponentProvider) end

function ComponentProvider.destroy(self: ComponentProvider) end

function ComponentProvider.addComponentClass(self: ComponentProvider, class: types.Component<any, any>)
	error("not yet implemented")
end

function ComponentProvider.getComponent<I, C>(
	self: ComponentProvider,
	class: types.Component<C, any, I>,
	instance: I
): types.Component<C, any, I>?
	error("not yet implemented")
end

function ComponentProvider.getAllComponents<I, C>(self: ComponentProvider, class: types.Component<C, any, I>)
	error("not yet implemented")
end

function ComponentProvider.addComponent<I, C>(
	self: ComponentProvider,
	class: types.Component<C, any, I>,
	instance: I
): types.Component<C, any, I>?
	error("not yet implemented")
end

function ComponentProvider.removeComponent<I, C>(
	self: ComponentProvider,
	class: types.Component<C, any, I>,
	instance: I
): types.Component<C, any, I>?
	error("not yet implemented")
end

export type ComponentProvider = typeof(ComponentProvider)
return providers.create(ComponentProvider)
