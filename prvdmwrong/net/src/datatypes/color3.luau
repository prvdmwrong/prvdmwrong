local types = require("@net/types")

local color3 = {} :: types.DataType<Color3>

function color3.write(value: Color3)
	error("not implemented")
end

function color3.read(currentBuffer: buffer, cursor: number): (Color3, number)
	error("not implemented")
end

return color3
