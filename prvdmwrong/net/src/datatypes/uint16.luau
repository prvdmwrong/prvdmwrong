local types = require("@net/types")

local uint16 = {} :: types.DataType<number>

function uint16.write(value: number)
	error("not implemented")
end

function uint16.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return uint16
