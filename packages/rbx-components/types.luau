local dependencies = require("../dependencies")
local roots = require("../roots")

export type Component<Self, Instance = Instance> = dependencies.Dependency<Self & {
	__index: Component<Self, Instance>,
	tag: string?,
	instanceCheck: (unknown) -> boolean,
	blacklistInstances: { Instance }?,
	whitelistInstances: { Instance }?,
	constructor: (self: Component<Self, Instance>, instance: Instance) -> ()?,
	added: (self: Component<Self, Instance>) -> ()?,
	removed: (self: Component<Self, Instance>) -> ()?,
	destroyed: (self: Component<Self, Instance>) -> ()?,
}, nil, Instance>

export type Root = roots.Root & {
	useModuleAsComponent: (root: Root, module: ModuleScript) -> Root,
	useModulesAsComponents: (root: Root, modules: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> Root,
	useComponent: (root: Root, component: Component<any, any>) -> Root,
	useComponents: (root: Root, components: { Component<any, any> }) -> Root,
}

export type RootPrivate = Root & {
	_hasComponentExtensions: true?,
	_classes: { Component<any, any> },
}

export type AnyComponent = Component<any, any>

return nil
