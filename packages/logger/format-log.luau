local types = require("./types")

local function formatLog<Templates>(self: types.Logger<Templates>, log: types.Log, errorInfoUrl: string?): string
	local formattedTemplate = string.format(log.template, table.unpack(log))

	local error = log.error
	local trace: string? = log.trace

	if error then
		trace = error.trace
		formattedTemplate = string.gsub(formattedTemplate, "ERROR_MESSAGE", error.message)
	end

	local id: string?

	-- TODO: find a better way to do ts while still being ergonomic
	for templateKey, template in (self :: any) :: { [string]: string } do
		if template == log.template then
			id = templateKey
			break
		end
	end

	if id then
		formattedTemplate ..= `\nID: {id}`
	end

	if errorInfoUrl then
		formattedTemplate ..= `\nLearn more: {errorInfoUrl}`
		if id then
			formattedTemplate ..= `#{string.lower(id)}`
		end
	end

	if trace then
		formattedTemplate ..= `\n---- Stack trace ----\n{trace}`
	end

	-- Labels are added from createLogger, so we don't add it here
	return string.gsub(formattedTemplate, "\n", "\n    ")
end

return formatLog
