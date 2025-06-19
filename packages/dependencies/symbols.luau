local symbol = require("../symbols")

local priority: symbol.Symbol<"prvdmwrong.dependencies.priority"> = symbol.symbol("prvdmwrong.dependencies.priority")
-- stylua: ignore
local subdependencies: symbol.Symbol<"prvdmwrong.dependencies.subdependencies"> = symbol.symbol("prvdmwrong.dependencies.subdependencies")

return {
	priority = priority,
	subdependencies = subdependencies,
}
