local dependency = require("../dependency")

export type Provider<Self> = dependency.Dependency<Self & {
	name: string?,
	start: (self: Provider<Self>) -> ()?,
}>

return nil
