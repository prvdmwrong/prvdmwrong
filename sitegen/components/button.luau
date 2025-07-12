local h = require("@sitegen/h")

local function Button(props: {
	href: string,
	[number]: h.Child,
})
	return h.a({
		href = props.href,
		class = "button",

		table.unpack(props),
	})
end

return Button
