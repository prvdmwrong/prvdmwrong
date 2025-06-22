local dependencies = require("../dependencies")
local roots = require("../roots")

export type Component<Self, Instance = Instance, Dependencies = nil> = dependencies.Dependency<Self & {
	__index: Component<Self, Instance, Dependencies>,
	tag: string?,
	blacklistInstances: { Instance }?,
	whitelistInstances: { Instance }?,
	constructor: (self: Component<Self, Instance, Dependencies>, instance: Instance) -> ()?,
	added: (self: Component<Self, Instance, Dependencies>) -> ()?,
	removed: (self: Component<Self, Instance, Dependencies>) -> ()?,
}, Dependencies, Instance>

export type Root = roots.Root & {
	useModuleAsComponent: (root: Root, module: ModuleScript) -> Root,
	useModulesAsComponents: (root: Root, modules: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> Root,
	useComponent: (root: Root, component: Component<any, any, any>) -> Root,
	useComponents: (root: Root, components: { Component<any, any, any> }) -> Root,
}

export type RootPrivate = Root & {
	_hasComponentExtensions: true?,
	_classes: { Component<any, any, any> },
}

return nil
