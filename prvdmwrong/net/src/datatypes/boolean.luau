local types = require("@net/types")

local boolean = {} :: types.DataType<boolean>

function boolean.write(value: boolean)
	error("not implemented")
end

function boolean.read(currentBuffer: buffer, cursor: number): (boolean, number)
	error("not implemented")
end

return boolean
