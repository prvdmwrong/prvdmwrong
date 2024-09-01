local function path(...: string)
	return table.concat({ ... }, "/")
end

return path
