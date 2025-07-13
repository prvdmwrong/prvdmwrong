local Button = require("@sitegen/components/button")
local CodeSnippet = require("@sitegen/components/code-snippet")
local Document = require("@sitegen/components/document")
local h = require("@sitegen/h")
local rootConfig = require("@lune-lib/root-config")
local siteBaseUrl = require("@sitegen/utils/site-base-url")

local CODE_EXAMPLE = [[
function MyProvider.constructor(
	self: MyProvider,
	dependencies: typeof(MyProvider.dependencies)
)
    self.value = otherProvider:someMethod()
end

function MyProvider.start(self: MyProvider)
    print("Value:", self.value)
end

export type MyProvider = typeof(MyProvider)
return prvd(MyProvider)]]

return function()
	return Document({
		header = {
			h.div({
				class = "hero-inner",

				h.section({
					class = "hero-lead",

					h.h1("Luau's Unstoppable Force"),
					h.p("The Luau provider framework with a fantastic featureset, extensibility, \
						and intuitiveness. Structure Luau projects with service providers. All \
						free from logistical nightmares and zero sprawling mazes of bloaty \
						dependencies."),

					Button({
						href = siteBaseUrl("learn"),
						"Get Started",
					}),
				}),

				h.section({
					class = "hero-supports",

					h.div({
						h.span("Available On"),
						h.div({
							class = "hero-supports-icons",
							h.a({
								href = "https://github.com/prvdmwrong/prvdmwrong",
							}),
							h.a({
								href = "https://pesde.dev/packages/prvdmwrong/prvdmwrong/latest/any",
							}),
							h.a({
								href = "https://wally.run/package/prvdmwrong/prvdmwrong",
							}),
							h.a({
								href = "https://github.com/prvdmwrong/prvdmwrong",
							}),
						}),
					}),

					h.div({
						h.span("Supported Runtimes"),
						h.div({
							class = "hero-supports-icons",
							h.a({}),
							h.a({}),
							h.a({}),
							h.a({}),
						}),
					}),
				}),

				h.section({
					class = "hero-code-example",

					CodeSnippet({
						language = "lua",

						CODE_EXAMPLE,
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
