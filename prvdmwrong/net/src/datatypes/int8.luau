local types = require("@net/types")

local int8 = {} :: types.DataType<number>

function int8.write(value: number)
	error("not implemented")
end

function int8.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return int8
