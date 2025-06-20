-- export type Symbol<T> = {
-- 	_symbol: (never) -> T,
-- }

export type Symbol<T> = T

local function symbol<T>(name: string): Symbol<T>
	return table.freeze(setmetatable({}, {
		__tostring = function()
			return name
		end,
	})) :: any
end

return table.freeze({
	symbol = symbol,
})
