local Log = require("@scripts/_utils/log")
local t = require("@scripts/_vendor/tiny")
local types = require("@scripts/_types")

local buildTypes = {}

export type BuildContext = {
	version: string,
	isDistributing: boolean,
	log: Log.Log,
}

export type Package = types.Package & {
	outputPath: string,
}

export type Processor = {
	loadOrder: number?,
	processesWhat: string,
	process: (self: Processor, package: types.Package, context: BuildContext) -> (),
	publish: (self: Processor, package: types.Package, context: BuildContext) -> ()?,
	postProcess: (self: Processor, context: BuildContext) -> (),
}

buildTypes.Processor = t.interface {
	loadOrder = t.optional(t.number),
	processesWhat = t.string,
	process = t.callback,
	publish = t.optional(t.callback),
}

return buildTypes
