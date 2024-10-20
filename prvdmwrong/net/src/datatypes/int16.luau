local types = require("@net/types")

local int16 = {} :: types.DataType<number>

function int16.write(value: number)
	error("not implemented")
end

function int16.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return int16
