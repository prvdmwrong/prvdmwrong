export type Symbol<T> = {
	_symbol: (never) -> T,
}

local function symbol<T>(name: string): Symbol<T>
	return table.freeze(setmetatable({} :: any, {
		__tostring = function()
			return name
		end,
	}))
end

return table.freeze({
	symbol = symbol,
})
