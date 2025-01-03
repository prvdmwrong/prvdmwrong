local StringBuilder = require("@scripts/_builders/string-builder")

export type TextBuilder = {
	append: (self: TextBuilder, ...string) -> TextBuilder,
	appendLn: (self: TextBuilder, ...string) -> TextBuilder,
	build: (self: TextBuilder) -> string,
	comment: (self: TextBuilder, ...string) -> TextBuilder,
	tag: (
		self: TextBuilder,
		elementName: string,
		attributes: { [string]: string },
		children: { TextBuilder }?
	) -> TextBuilder,
	h1: (self: TextBuilder, header: string, useElementTag: boolean?) -> TextBuilder,
	h2: (self: TextBuilder, header: string, useElementTag: boolean?) -> TextBuilder,
	h3: (self: TextBuilder, header: string, useElementTag: boolean?) -> TextBuilder,
	h4: (self: TextBuilder, header: string, useElementTag: boolean?) -> TextBuilder,
	h5: (self: TextBuilder, header: string, useElementTag: boolean?) -> TextBuilder,
	divider: (self: TextBuilder) -> TextBuilder,
}
