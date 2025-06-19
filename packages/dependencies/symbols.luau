local symbol = require("../symbols")

local priority: symbol.Symbol<"prvdmwrong.dependencies.priority"> =
	symbol.symbol("prvdmwrong.dependencies.priority") :: any
local subdependencies: symbol.Symbol<"prvdmwrong.dependencies.subdependencies"> =
	symbol.symbol("prvdmwrong.dependencies.subdependencies") :: any

return table.freeze({
	priority = priority,
	subdependencies = subdependencies,
})
