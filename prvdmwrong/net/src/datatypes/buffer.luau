local types = require("@net/types")

local buffer = {} :: types.DataType<buffer>

function buffer.write(value: buffer)
	error("not implemented")
end

function buffer.read(currentBuffer: buffer, cursor: number): (buffer, number)
	error("not implemented")
end

return buffer
