local Log = require("@scripts/_utils/log")
local t = require("@scripts/_vendor/tiny")
local types = require("@scripts/_types")

local regenTypes = {}

export type Generator = {
	loadOrder: number?,
	generate: (self: Generator, package: { types.Package }, log: Log.Log) -> (),
}

regenTypes.Generator = t.interface {
	loadOrder = t.optional(t.number),
	generate = t.callback,
}

return regenTypes
