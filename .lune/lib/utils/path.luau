local process = require("@lune/process")

local delimiter = if process.os == "windows" then "\\" else "/"

local function path(...: string)
	return table.concat({ ... }, delimiter)
end

return path
