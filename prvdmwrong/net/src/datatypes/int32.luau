local types = require("@net/types")

local int32 = {} :: types.DataType<number>

function int32.write(value: number)
	error("not implemented")
end

function int32.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return int32
