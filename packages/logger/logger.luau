local allowWebLinks = require("./allow-web-links")
local formatLog = require("./format-log")
local runtime = require("../runtime")
local types = require("./types")

local task = runtime.task
local warn = runtime.warn

local function Logger<T>(label: string, templates: T, errorInfoUrl: string?): types.Logger<T>
	local self = {} :: types.Logger<T>
	label = `[{label}] `
	errorInfoUrl = if allowWebLinks then errorInfoUrl else nil

	function self:warn(log)
		warn(label .. formatLog(self, log, errorInfoUrl))
	end

	function self:error(log)
		task.spawn(error, label .. formatLog(self, log, errorInfoUrl), 0)
	end

	function self:fatalError(log)
		error(label .. formatLog(self, log, errorInfoUrl))
	end

	setmetatable(self :: any, { __index = templates })
	return self
end

return Logger
