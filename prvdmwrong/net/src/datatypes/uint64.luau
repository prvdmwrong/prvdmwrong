local types = require("@net/types")

local uint64 = {} :: types.DataType<number>

function uint64.write(value: number)
	error("not implemented")
end

function uint64.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return uint64
