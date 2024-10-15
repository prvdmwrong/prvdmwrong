local stdio = require("@lune/stdio")

local RESET_COLOR = stdio.color("reset")
local RESET_STYLE = stdio.style("reset")

local function tostringAll(...: unknown): string
	local segments = {}

	for index = 1, select("#", ...) do
		table.insert(segments, tostring(select(index, ...) :: any))
	end

	return table.concat(segments, " ")
end

local function createColor(color: stdio.Color)
	return function(...: string)
		return stdio.color(color) .. tostringAll(...) .. RESET_COLOR
	end
end

local function createStyle(style: stdio.Style)
	return function(...: string)
		return stdio.style(style) .. tostringAll(...) .. RESET_STYLE
	end
end

local stylune = {}

do
	stylune.red = createColor("red")
	stylune.yellow = createColor("yellow")
	stylune.green = createColor("green")
	stylune.cyan = createColor("cyan")
	stylune.blue = createColor("blue")
	stylune.purple = createColor("purple")
	stylune.white = createColor("white")
	stylune.black = createColor("black")

	stylune.bold = createStyle("bold")
	stylune.dim = createStyle("dim")
end

return stylune
