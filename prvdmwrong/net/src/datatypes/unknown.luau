local types = require("@net/types")

local unknown = {} :: types.DataType<unknown>

function unknown.write(value: unknown)
	error("not implemented")
end

function unknown.read(currentBuffer: buffer, cursor: number): (unknown, number)
	error("not implemented")
end

return unknown
