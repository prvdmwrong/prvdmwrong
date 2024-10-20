local types = require("@net/types")

local cframe = {} :: types.DataType<CFrame>

function cframe.write(value: CFrame)
	error("not implemented")
end

function cframe.read(currentBuffer: buffer, cursor: number): (CFrame, number)
	error("not implemented")
end

return cframe
