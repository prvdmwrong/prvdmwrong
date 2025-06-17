local allowWebLinks = require("@self/allow-web-links")
local createLogger = require("@self/create-logger")
local formatLog = require("@self/format-log")
local parseError = require("@self/parse-error")
local standardErrorInfoUrl = require("@self/standard-error-info-url")
local types = require("@self/types")

export type Logger<Templates> = types.Logger<Templates>
export type Log = types.Log
export type Error = types.Error

return table.freeze({
	createLogger = createLogger,
	formatLog = formatLog,
	parseError = parseError,
	allowWebLinks = allowWebLinks,
	standardErrorInfoUrl = standardErrorInfoUrl,
})
