local process = require("@lune/process")
local stdio = require("@lune/stdio")
local types = require("@lune-lib/types")

local function selectPackages(packages: { types.Package }): {
	names: { string },
	nameToPackage: { [string]: types.Package },
	selected: { string },
}
	local packageNames = {}
	local nameToPackage = {}

	local selected: { string } = {}

	table.sort(packages, function(lhs, rhs)
		return lhs.config.name < rhs.config.name
	end)

	for _, package in packages do
		local name = package.config.name
		table.insert(packageNames, name)
		nameToPackage[name] = package
	end

	if #process.args == 0 then
		for _, index in stdio.prompt("multiselect", "Which packages to build?", packageNames) do
			table.insert(selected, packageNames[index])
		end
	elseif table.find(process.args, "all") then
		selected = table.clone(packageNames)
	else
		table.move(process.args, 1, #process.args, 1, selected)
	end

	return {
		names = packageNames,
		nameToPackage = nameToPackage,
		selected = selected,
	}
end

return selectPackages
