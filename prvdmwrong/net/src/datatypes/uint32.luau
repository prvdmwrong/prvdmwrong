local types = require("@net/types")

local uint32 = {} :: types.DataType<number>

function uint32.write(value: number)
	error("not implemented")
end

function uint32.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return uint32
