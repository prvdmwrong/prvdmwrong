local componentClasses = require("@self/component-classes")
local create = require("@self/create")
local extendRoot = require("@self/extend-root")
local types = require("@self/types")

export type Component<Self, Instance = Instance, Dependencies = nil> = types.Component<Self, Instance, Dependencies>
export type Root = types.Root

local rbxComponents = table.freeze({
	create = create,
	extendRoot = extendRoot,
	_ = table.freeze({
		componentClasses = componentClasses,
	}),
})

return rbxComponents
