local Button = require("@sitegen/components/button")
local Document = require("@sitegen/components/document")
local h = require("@sitegen/h")
local rootConfig = require("@lune-lib/root-config")
local siteBaseUrl = require("@sitegen/utils/site-base-url")

local CODE_EXAMPLE = [[
function MyProvider.constructor(
	self: MyProvider, 
	dependencies: typeof(MyProvider.subdependencies)
)
    self.value = otherProvider:someMethod()
end

function MyProvider.start(self: MyProvider)
    print(self.value)
end

export type MyProvider = typeof(MyProvider)
return prvd(MyProvider)]]

local function LearnIndex()
	return Document({
		main = {
			h.h1(string.rep("placeholder<br/>", 80)),
		},
	})
end

return LearnIndex
