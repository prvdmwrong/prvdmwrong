local types = require("@net/types")

local vector2 = {} :: types.DataType<Vector2>

function vector2.write(value: Vector2)
	error("not implemented")
end

function vector2.read(currentBuffer: buffer, cursor: number): (Vector2, number)
	error("not implemented")
end

return vector2
