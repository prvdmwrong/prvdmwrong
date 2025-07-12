local componentClasses = require("@self/component-classes")
local create = require("@self/create")
local extendRoot = require("@self/extend-root")
local types = require("@self/types")

export type Component<Self, Instance = Instance> = types.Component<Self, Instance>
export type Root = types.Root

local components = {
	create = create,
	extendRoot = extendRoot,
	_ = table.freeze({
		componentClasses = componentClasses,
	}),
}

local mt = {}

function mt.__call<Self>(_, component: Self): types.Component<Self, any>
	return create(component)
end

table.freeze(mt)
return table.freeze(setmetatable(components, mt))
