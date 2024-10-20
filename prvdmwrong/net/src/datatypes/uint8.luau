local types = require("@net/types")

local uint8 = {} :: types.DataType<number>

function uint8.write(value: number)
	error("not implemented")
end

function uint8.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return uint8
