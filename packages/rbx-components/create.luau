local componentClasses = require("./component-classes")
local types = require("./types")

-- TODO: prvdmwrong/classes package?
local function create<Self>(self: Self): types.Component<Self, any>
	local component: types.Component<Self> = self :: any

	if component.__index == nil then
		component.__index = component
	end

	-- TODO: abstract nameOf

	if component.new == nil then
		function component.new(instance: any)
			local self: types.Component<Self> = setmetatable({}, component) :: any
			if component.constructor then
				return component.constructor(self, instance) or self
			end
			return self
		end
	end

	componentClasses[component] = true
	return component
end

return create
