export type Tag<Properties = { [any]: any }> = (props: PropertyTable<Properties>) -> string
export type PropertyTable<Properties = { [any]: any }> = Properties & { [ChildrenKey]: Child? }
type Child = string | { string }
type ChildrenKey = { __childrenKey: never? }
type BasicProperties = { class: string? }

local html = {
	children = newproxy() :: ChildrenKey,
}

local tagsMt = {}
type Self = typeof(tagsMt)

function tagsMt.__index(self: Self, value: string): Tag
	local tag: Tag = function(props)
		if next(props) == nil then
			return `<{value}/>`
		end

		local outputProps = {}
		local children = {}

		for k, v in (props :: any) :: { [any]: any } do
			if k == html.children then
			end
		end
		-- todo properties
		error()
	end :: any

	self[value] = tag
	return tag
end

html.tags = setmetatable({}, tagsMt) :: {
	div: Tag<BasicProperties>,
	h1: Tag<BasicProperties>,
	h2: Tag<BasicProperties>,
	h3: Tag<BasicProperties>,
	h4: Tag<BasicProperties>,
	h5: Tag<BasicProperties>,
	p: Tag<BasicProperties>,
	span: Tag<BasicProperties>,
	b: Tag<BasicProperties>,
	u: Tag<BasicProperties>,
	i: Tag<BasicProperties>,
	section: Tag<BasicProperties>,
	main: Tag<BasicProperties>,
}

return html
