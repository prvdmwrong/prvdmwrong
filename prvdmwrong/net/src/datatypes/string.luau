local types = require("@net/types")

local string = {} :: types.DataType<string>

function string.write(value: string)
	error("not implemented")
end

function string.read(currentBuffer: buffer, cursor: number): (string, number)
	error("not implemented")
end

return string
