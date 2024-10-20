export type Log = {
	print: (...string) -> (),
	indent: () -> (),
	unIndent: () -> (),
}

local INDENT = "  "

local function concatAll(...): string
	local segments = {}
	for index = 1, select("#", ...) do
		table.insert(segments, tostring(select(index, ...) :: any))
	end
	return table.concat(segments, " ")
end

local function Log(): Log
	local self = {} :: Log
	local indent = 0

	function self.print(...: string)
		print(INDENT:rep(indent) .. concatAll(...))
	end

	function self.indent()
		indent += 1
	end

	function self.unIndent()
		if indent > 0 then
			indent -= 1
		end
	end

	return self
end

return Log
