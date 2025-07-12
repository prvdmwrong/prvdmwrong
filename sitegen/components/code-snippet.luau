local h = require("@sitegen/h")

local function CodeSnippet(props: {
	language: "lua" | "shell" | "typescript",

	[number]: h.Child,
})
	return h.pre({
		class = `code-snippet`,

		h.code({
			class = `language-{props.language}`,

			table.unpack(props),
		}),
	})
end

return CodeSnippet
