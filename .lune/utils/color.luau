--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

local stdio = require("@lune/stdio")

local STDIO_RESET = stdio.color("reset")

local function tostringAll(...: unknown): string
	local segments = {}

	for index = 1, select("#", ...) do
		table.insert(segments, tostring(select(index, ...)))
	end

	return table.concat(segments, " ")
end

local function createColor(color: string)
	return function(...: string)
		return color .. tostringAll(...) .. STDIO_RESET
	end
end

local color = {}

do
	color.red = createColor(stdio.color("red"))
	color.yellow = createColor(stdio.color("yellow"))
	color.green = createColor(stdio.color("green"))
	color.cyan = createColor(stdio.color("cyan"))
	color.blue = createColor(stdio.color("blue"))
	color.purple = createColor(stdio.color("purple"))
	color.white = createColor(stdio.color("white"))
	color.black = createColor(stdio.color("black"))
end

return color
