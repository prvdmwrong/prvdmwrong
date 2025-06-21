local Navbar = require("@sitegen/components/navbar")
local h = require("@sitegen/h")
local siteBaseUrl = require("@sitegen/utils/site-base-url")

local function Document(props: {
	title: string?,
	main: h.Child,
	header: h.Child?,
	extraHead: h.Child?,
})
	return {
		"<!DOCTYPE html>",
		h.html({
			lang = "en",
			h.head({
				h.meta({ charset = "UTF-8" }),
				h.meta({ name = "viewport", content = "width=device-width, initial-scale=1.0" }),

				h.title((if props.title then `{props.title} - ` else "") .. "Prvd 'M Wrong"),

				h.link({ rel = "stylesheet", href = siteBaseUrl("stylesheets/reset.css") }),
				h.link({ rel = "stylesheet", href = siteBaseUrl("stylesheets/fonts.css") }),
				h.link({ rel = "stylesheet", href = siteBaseUrl("stylesheets/common.css") }),

				props.extraHead :: any,
			}),
			h.body({
				Navbar(),
				props.header and h.header(props.header) :: any,
				h.main(props.main),
			}),
		}),
	}
end

return Document
