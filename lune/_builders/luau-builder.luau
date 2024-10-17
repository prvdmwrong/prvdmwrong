local StringBuilder = require("@scripts/_builders/string-builder")

export type LuauBuilder = {
	append: (self: LuauBuilder, ...string) -> LuauBuilder,
	appendLn: (self: LuauBuilder, ...string) -> LuauBuilder,
	build: (self: LuauBuilder) -> string,
	comment: (self: LuauBuilder, ...string) -> LuauBuilder,
	commentLn: (self: LuauBuilder, ...string) -> LuauBuilder,
	declare: (self: LuauBuilder, variable: string, initialize: string?) -> LuauBuilder,
	numericLoop: (
		self: LuauBuilder,
		init: number,
		condition: string,
		updater: string?
	) -> (builders: { LuauBuilder }) -> LuauBuilder,
	whileLoop: (self: LuauBuilder, condition: string) -> (builders: { LuauBuilder }) -> LuauBuilder,
	repeatUntil: (self: LuauBuilder, condition: string) -> (builders: { LuauBuilder }) -> LuauBuilder,
	iterate: (
		self: LuauBuilder,
		key: string,
		value: string,
		iterator: string
	) -> (builders: { LuauBuilder }) -> LuauBuilder,
	ifCondition: (
		self: LuauBuilder,
		condition: string,
		builders: { LuauBuilder },
		elseIf: { LuauBuilder }?,
		elseDo: { LuauBuilder }?
	) -> LuauBuilder,
	declareFunction: (
		self: LuauBuilder,
		identifier: string,
		arguments: string,
		returns: string?,
		inline: boolean?
	) -> (builders: { LuauBuilder }) -> LuauBuilder,
}
