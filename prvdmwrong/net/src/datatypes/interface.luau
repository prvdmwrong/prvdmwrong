local types = require("@net/types")

local function interface<Interface>(interface: Interface & { [string]: types.DataType<unknown> }): types.DataType<{}>
	local interface = {} :: types.DataType<{}>

	function interface.write(value: {})
		error("not implemented")
	end

	function interface.read(currentBuffer: buffer, cursor: number): ({}, number)
		error("not implemented")
	end

	return interface
end

return interface
