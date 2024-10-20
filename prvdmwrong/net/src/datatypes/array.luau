local types = require("@net/types")

local function array<T>(value: types.DataType<T>): types.DataType<{ T }>
	local array = {} :: types.DataType<{ T }>

	function array.write(value: { T })
		error("not implemented")
	end

	function array.read(currentBuffer: buffer, cursor: number): ({ T }, number)
		error("not implemented")
	end

	return array
end

return array
