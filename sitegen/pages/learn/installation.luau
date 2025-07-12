local Article = require("@sitegen/components/article")
local commonUrls = require("@sitegen/config/common-urls")
local h = require("@sitegen/h")

return function()
	return Article({
		title = "Installation",
		content = {
			h.p("Prvd 'M Wrong is distributed as several packages that needs to be installed into \
			    your game."),
		},
		sections = {
			{
				title = "Templates",
				content = {
					h.p("TBA"),
				},
			},
			{
				title = "Installation",
				content = {
					h.p("TBA"),
				},
			},
			{
				title = "Build from Source",
				content = {
					h.p("TBA"),
				},
			},
		},
	})
end
