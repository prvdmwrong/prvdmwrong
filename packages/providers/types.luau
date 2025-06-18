local dependencies = require("../dependencies")

export type Provider<Self, Dependencies = nil> = dependencies.Dependency<Self & {
	__index: Provider<Self, Dependencies>,
	name: string?,
	constructor: ((self: Provider<Self, Dependencies>, dependencies: Dependencies) -> ())?,
	start: (self: Provider<Self, Dependencies>) -> ()?,
	finish: (self: Provider<Self, Dependencies>) -> ()?,
}, Dependencies>

return nil
