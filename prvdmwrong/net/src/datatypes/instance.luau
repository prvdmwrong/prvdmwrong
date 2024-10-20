local types = require("@net/types")

local instance = {} :: types.DataType<Instance>

function instance.write(value: Instance)
	error("not implemented")
end

function instance.read(currentBuffer: buffer, cursor: number): (Instance, number)
	error("not implemented")
end

return instance
