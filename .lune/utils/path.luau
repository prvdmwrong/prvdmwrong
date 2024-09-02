--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local function path(...: string)
	return table.concat({ ... }, "/")
end

return path
