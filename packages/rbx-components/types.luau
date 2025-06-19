local dependencies = require("../dependencies")

export type ComponentClass<Self, Dependencies, Instance> = dependencies.Dependency<Self & {
	tag: string,
	whitelistDescendants: { Instance },
	blacklistDescendants: { Instance },
}, Dependencies, Instance>

return nil
