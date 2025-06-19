export type Symbol<T> = {
	type: "Symbol",
	name: T,
}

local symbolMt = {}

function symbolMt.__tostring(self: Symbol<any>)
	return self.name
end

table.freeze(symbolMt)

local function symbol<T>(name: T): Symbol<T>
	local self: Symbol<T> = {
		type = "Symbol",
		name = name,
	}

	table.freeze(self)
	setmetatable(self, symbolMt)
	return self :: any
end

return table.freeze({
	symbol = symbol,
})
