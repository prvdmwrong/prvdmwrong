local forEach = require("@sitegen/utils/for-each")
local h = require("@sitegen/h")
local navPages = require("@sitegen/config/nav-pages")

local function Navbar()
	return h.nav({
		class = "navbar",

		h.div({
			class = "navbar-inner",

			h.p("Prvd 'M Wrong"),

			forEach(navPages, function(index, page)
				return index, h.a({
					href = page.href,
					page.title,
				})
			end) :: any,
		}),
	})
end

return Navbar
