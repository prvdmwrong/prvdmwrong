local Article = require("@sitegen/components/article")
local commonUrls = require("@sitegen/config/common-urls")
local h = require("@sitegen/h")

return function()
	return Article({
		title = "Learn Prvd 'M Wrong",
		content = {
			h.p("Congratulations on choosing Prvd 'M Wrong, you’re finally making good decisions!"),
			h.p("You will learn how to build great projects with Prvd 'M Wrong, even if you never used \
			it before, with advice from maintainers who know Prvd 'M Wrong best."),
		},
		sections = {
			{
				title = "Expectations",
				content = {
					h.p("Prvd 'M Wrong expects:"),
					h.ul({
						h.li("That you're comfortable with the Luau scripting language."),
						h.li("That — if you will use Roblox-specific packages — you're familiar with Roblox"),
					}),
					h.p("Some articles might challenge you more than others. Remember, Prvd 'M Wrong is \
				built with you in mind, but it may still take a bit of time to absorb some \
				concepts. Take your time and explore at your own pace."),
				},
			},
			{
				title = "Support",
				content = {
					h.p("Prvd 'M Wrong is built with you in mind and our documentation aims to be as \
				    useful and comprehensive as possible. However, you might need specific advice \
					on an issue, perhaps you may want to learn Prvd 'M Wrong through other means, \
					or you caught a bug."),
					h.p({
						"Whatever you're looking for, feel free to swing by our ",
						h.a({
							href = commonUrls.rossThread,
							"dedicated thread over the Roblox OSS Discord server.",
						}),
						" Maintainers drop in frequently alongside eager \
						Prvd 'M Wrong users.",
					}),
				},
			},
			{
				title = "Using the Documentation",
				content = {
					h.p("The Prvd 'M Wrong documentation aims to be as useful and comprehensive as \
				        possible. You can open the documentation settings by clicking the gear \
						icon in the top right corner."),
					h.p("These customization settings will persist between sessions:"),
					h.ul({
						h.li("Dark, light and sepia color schemes"),
						h.li("Preferred monospace fonts for code snippets"),
						h.li("Relevant documentation for Luau and Roblox TypeScript"),
					}),
				},
			},
		},
	})
end
