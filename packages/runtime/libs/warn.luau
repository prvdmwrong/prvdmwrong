local implementations = require("../implementations")

local supportedRuntimes = implementations.supportedRuntimes
local implementFunction = implementations.implementFunction

local function tostringTuple(...: any)
	local stringified = {}
	for index = 1, select("#", ...) do
		table.insert(stringified, tostring(select(index, ...)))
	end
	return table.concat(stringified, " ")
end

local warn: <T...>(T...) -> () = implementFunction("warn", {
	[supportedRuntimes.roblox] = {
		new = function()
			return warn
		end,
	},
	[supportedRuntimes.luau] = {
		implementation = function<T...>(...: T...)
			print(`\27[0;33m{tostringTuple(...)}\27[0m`)
		end,
	},
})

return warn
