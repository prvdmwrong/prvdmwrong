local types = require("./types")

local function sortByPriority(dependencies: { types.Dependency<unknown> })
	table.sort(dependencies, function(left: any, right: any)
		if left.priority ~= right.priority then
			return (left.priority or 1) > (right.priority or 1)
		end
		local leftIndex = table.find(dependencies, left)
		local rightIndex = table.find(dependencies, right)
		return leftIndex < rightIndex
	end)
end

return sortByPriority
