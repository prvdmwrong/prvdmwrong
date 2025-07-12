local h = require("@sitegen/h")

export type SitemapEntry<Props = nil> = {
	path: string,
	render: (Props) -> h.Child,
	props: Props,
}

local sitemap: { SitemapEntry<any> } = {
	{ path = "", render = require("@sitegen/pages/index") },
	{ path = "learn", render = require("@sitegen/pages/learn/index") },
	{ path = "learn/installation", render = require("@sitegen/pages/learn/installation") },
}

return sitemap
