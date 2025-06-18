local dependencies = require("../dependencies")

export type Provider<Self> = dependencies.Dependency<Self & {
	__index: Provider<Self>,
	name: string?,
	new: () -> Provider<Self>,
	constructor: ((self: Provider<Self>) -> ())?,
	start: (self: Provider<Self>) -> ()?,
}>

return nil
