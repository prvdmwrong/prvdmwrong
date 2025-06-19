local stdio = require("@lune/stdio")

local RESET_STYLE = stdio.style("reset")
local RESET_COLOR = stdio.color("reset")

local function wrapStyle(style: stdio.Style)
	local code = stdio.style(style)
	return function(str: string)
		return code .. str .. RESET_STYLE
	end
end

local function wrapColor(color: stdio.Color)
	local code = stdio.color(color)
	return function(str: string)
		return code .. str .. RESET_COLOR
	end
end

local function wrapCode(code: string)
	return function()
		stdio.write(code)
	end
end

return table.freeze({
	dim = wrapStyle("dim"),
	bold = wrapStyle("bold"),

	red = wrapColor("red"),
	yellow = wrapColor("yellow"),
	green = wrapColor("green"),
	cyan = wrapColor("cyan"),
	blue = wrapColor("blue"),
	purple = wrapColor("purple"),
	black = wrapColor("black"),
	white = wrapColor("white"),

	clearLine = wrapCode("\x1b[2K\x1b[2A"),
})
