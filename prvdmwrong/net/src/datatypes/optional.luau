local types = require("@net/types")

local function optional<T>(value: types.DataType<T>): types.DataType<T?>
	local optional = {} :: types.DataType<T?>

	function optional.write(value: T?)
		error("not implemented")
	end

	function optional.read(currentBuffer: buffer, cursor: number): (T?, number)
		error("not implemented")
	end

	return optional
end

return optional
