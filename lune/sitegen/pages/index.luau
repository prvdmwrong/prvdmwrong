local Button = require("@sitegen/components/button")
local CodeSnippet = require("@sitegen/components/code-snippet")
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

local function Index()
	return Document({
		header = {
			h.div({
				class = "hero-inner",

				h.section({
					class = "hero-left",

					h.section({
						class = "hero-lead",

						h.h1("Start smarter, not harder."),
						h.p("Prvd 'M Wrong is the Luau provider framework made to free you from logistical \
								nightmares so you can focus just on your project's logic."),

						h.span("Supported runtimes"),
					}),

					h.nav({
						class = "hero-buttons",

						Button({
							href = siteBaseUrl("learn"),
							"Learn More",
						}),

						Button({
							href = rootConfig.repository,
							"GitHub",
						}),
					}),
				}),

				h.section({
					class = "hero-right",

					h.section({
						class = "hero-code-example",

						CodeSnippet({
							language = "lua",

							CODE_EXAMPLE,
						}),
					}),
				}),
			}),
		},
		main = {
			h.section({}),
			h.h1(string.rep("placeholder<br/>", 80)),
		},
		extraHead = {
			h.link({ rel = "stylesheet", href = siteBaseUrl("stylesheets/landing.css") }),
		},
	})
end

return Index
