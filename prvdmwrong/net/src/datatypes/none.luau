local types = require("@net/types")

local none = {} :: types.DataType<nil>

function none.write(value: nil) end

function none.read(currentBuffer: buffer, cursor: number): (nil, number)
	return nil, 0
end

return none
