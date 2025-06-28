local siteUrls = require("@sitegen/config/site-urls")

local function siteBaseUrl(suffix: string)
	return siteUrls.base .. "/" .. suffix
end

return siteBaseUrl
