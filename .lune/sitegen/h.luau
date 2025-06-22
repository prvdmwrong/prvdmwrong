export type Child = string | { Child }

local function flatten(child: Child): string
	if typeof(child) == "string" then
		return child
	else
		local flat = ""
		for _, sub_child in child do
			flat ..= flatten(sub_child)
		end
		return flat
	end
end

local function escape(attribute: string): string
	attribute = string.gsub(attribute, "&", "&amp;")
	attribute = string.gsub(attribute, "<", "&lt;")
	attribute = string.gsub(attribute, ">", "&gt;")
	attribute = string.gsub(attribute, "'", "&apos;")
	attribute = string.gsub(attribute, '"', "&quot;")
	return attribute
end

local function createElement(tag: string)
	local function element(props: string | { [unknown]: unknown })
		if typeof(props) == "table" then
			local attributes = ""
			for key, value in props do
				if typeof(key) == "string" then
					assert(typeof(value) == "string", "HTML attribute value must be string")
					attributes ..= ` {key}="{escape(value)}"`
				end
			end
			return `<{tag}{attributes}>{flatten({ table.unpack(props :: any) })}</{tag}>`
		end

		return `<{tag}>{props}</{tag}>`
	end

	return element
end

return table.freeze({
	escape = escape,
	flatten = flatten,

	div = createElement("div"),
	span = createElement("span"),
	h1 = createElement("h1"),
	h2 = createElement("h2"),
	h3 = createElement("h3"),
	h4 = createElement("h4"),
	h5 = createElement("h5"),
	h6 = createElement("h6"),
	p = createElement("p"),
	a = createElement("a"),
	img = createElement("img"),
	button = createElement("button"),
	input = createElement("input"),
	label = createElement("label"),
	textarea = createElement("textarea"),
	select = createElement("select"),
	option = createElement("option"),
	ul = createElement("ul"),
	ol = createElement("ol"),
	li = createElement("li"),
	table = createElement("table"),
	tr = createElement("tr"),
	td = createElement("td"),
	th = createElement("th"),
	thead = createElement("thead"),
	tbody = createElement("tbody"),
	tfoot = createElement("tfoot"),
	form = createElement("form"),
	br = createElement("br"),
	hr = createElement("hr"),
	strong = createElement("strong"),
	b = createElement("b"),
	em = createElement("em"),
	i = createElement("i"),
	u = createElement("u"),
	s = createElement("s"),
	sup = createElement("sup"),
	sub = createElement("sub"),
	small = createElement("small"),
	code = createElement("code"),
	pre = createElement("pre"),
	blockquote = createElement("blockquote"),
	nav = createElement("nav"),
	header = createElement("header"),
	footer = createElement("footer"),
	section = createElement("section"),
	article = createElement("article"),
	aside = createElement("aside"),
	main = createElement("main"),
	details = createElement("details"),
	summary = createElement("summary"),
	dialog = createElement("dialog"),
	time = createElement("time"),
	address = createElement("address"),
	mark = createElement("mark"),
	progress = createElement("progress"),
	meter = createElement("meter"),
	caption = createElement("caption"),
	figure = createElement("figure"),
	figcaption = createElement("figcaption"),
	legend = createElement("legend"),
	fieldset = createElement("fieldset"),
	dfn = createElement("dfn"),
	kbd = createElement("kbd"),
	var = createElement("var"),
	cite = createElement("cite"),
	q = createElement("q"),

	html = createElement("html"),
	head = createElement("head"),
	title = createElement("title"),
	meta = createElement("meta"),
	link = createElement("link"),
	style = createElement("style"),
	body = createElement("body"),

	script = createElement("script"),
	noscript = createElement("noscript"),

	audio = createElement("audio"),
	video = createElement("video"),
	source = createElement("source"),
	track = createElement("track"),
	iframe = createElement("iframe"),
	canvas = createElement("canvas"),
	svg = createElement("svg"),
})
