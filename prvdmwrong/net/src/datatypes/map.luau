local types = require("@net/types")

local function map<K, V>(keys: types.DataType<K>, values: types.DataType<V>): types.DataType<{ [K]: V }>
	local map = {} :: types.DataType<{ [K]: V }>

	function map.write(value: { [K]: V })
		error("not implemented")
	end

	function map.read(currentBuffer: buffer, cursor: number): ({ [K]: V }, number)
		error("not implemented")
	end

	return map
end

return map
