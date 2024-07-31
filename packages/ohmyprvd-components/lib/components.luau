local package = script.Parent
local prvd = require(package.Parent.prvd)

local components = {}
type Self = typeof(components)

components.loadOrder = 0
function components.onInit(self: Self)
  -- WIP
end

return prvd.new("ohmyprvd-components", components)
