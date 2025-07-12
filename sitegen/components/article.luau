local Document = require("./document")
local h = require("@sitegen/h")
local siteBaseUrl = require("@sitegen/utils/site-base-url")

export type ArticleSection = {
	title: string,
	content: { h.Child },
	sections: { ArticleSection }?,
}

local headings = {
	h.h1,
	h.h2,
	h.h3,
	h.h4,
	h.h5,
	h.h6,
}

local defaultHeading = h.h6

local function Article(props: ArticleSection)
	local toc = {}

	local content = {
		h.h1(props.title) :: any,
		props.content,
	}

	local function processSections(sections: { ArticleSection }, depth: number)
		for _, section in sections do
			table.insert(content, {
				(headings[depth] or defaultHeading)(section.title),
				section.content :: any,
			})

			if section.sections then
				processSections(section.sections, depth + 1)
			end
		end
	end

	if props.sections then
		processSections(props.sections, 1)
	end

	return Document({
		title = props.title,
		extraHead = {
			h.link({ rel = "stylesheet", href = siteBaseUrl("stylesheets/article.css") }),
		},
		main = {
			h.section({
				class = "article-container",

				h.nav({
					class = "article-nav",
				}),

				h.article({
					class = "article-content",
					content,
				}),

				h.div({
					class = "article-toc",
					toc,
				}),
			}),
		},
	})
end

return Article
