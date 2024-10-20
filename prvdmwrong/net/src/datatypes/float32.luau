local types = require("@net/types")

local float32 = {} :: types.DataType<number>

function float32.write(value: number)
	error("not implemented")
end

function float32.read(currentBuffer: buffer, cursor: number): (number, number)
	error("not implemented")
end

return float32
