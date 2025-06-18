local types = require("./types")

local subdependencies = newproxy(true)

getmetatable(subdependencies).__tostring = function()
	return "prvdmwrong.subdependencies"
end

return subdependencies :: types.subdependencies
