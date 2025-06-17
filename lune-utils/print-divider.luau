local styles = require("./styles")

local LINE_COUNT = 100

local bold = styles.bold
local cyan = styles.cyan

local function printDivider(str: string, lineCount: number?)
	local dashRepeats = ((lineCount or LINE_COUNT) - str:len()) * 0.5
	local extraIfUneven = if str:len() % 2 ~= 0 then 1 else 0
	return print(cyan(bold(`{string.rep("—", dashRepeats)} {str} {string.rep("—", dashRepeats + extraIfUneven)}`)))
end

return printDivider
