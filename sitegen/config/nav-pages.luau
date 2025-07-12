local siteBaseUrl = require("@sitegen/utils/site-base-url")

export type NavPage = {
	id: string,
	href: string,
	title: string,
}

return {
	{
		id = "learn",
		href = siteBaseUrl("learn"),
		title = "Learn",
	},
	{
		id = "api",
		href = siteBaseUrl("api"),
		title = "API",
	},
	{
		id = "releases",
		href = siteBaseUrl("releases"),
		title = "Releases",
	},
	{
		id = "blog",
		href = siteBaseUrl("blog"),
		title = "Blog",
	},
} :: { NavPage }
