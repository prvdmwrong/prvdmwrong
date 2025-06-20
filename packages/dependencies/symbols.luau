local symbol = require("../symbols")

local priority: symbol.Symbol<"prvd.priority"> = symbol.symbol("prvd.priority")
local subdependencies: symbol.Symbol<"prvd.subdependencies"> = symbol.symbol("prvd.subdependencies")

return table.freeze({
	priority = priority,
	subdependencies = subdependencies,
})
