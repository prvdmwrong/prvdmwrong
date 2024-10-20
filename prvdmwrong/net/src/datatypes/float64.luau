local types = require("@net/types")

local float64 = {} :: types.DataType<number>

function float64.write(value: number)
	error("not implemented")
end

function float64.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return float64
