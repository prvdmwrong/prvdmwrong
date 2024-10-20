local types = require("@net/types")

local vector3 = {} :: types.DataType<Vector3>

function vector3.write(value: Vector3)
	error("not implemented")
end

function vector3.read(currentBuffer: buffer, cursor: number): (Vector3, number)
	error("not implemented")
end

return vector3
