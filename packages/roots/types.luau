local lifecycles = require("../lifecycles")
local providers = require("../providers")

type Set<T> = { [T]: true }

export type Root = {
	type: "Root",

	start: (root: Root) -> StartedRoot,

	useModule: (root: Root, module: ModuleScript) -> Root,
	useModules: (root: Root, modules: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> Root,
	useRoot: (root: Root, root: Root) -> Root,
	useRoots: (root: Root, roots: { Root }) -> Root,
	useProvider: (root: Root, provider: providers.Provider<unknown>) -> Root,
	useProviders: (root: Root, providers: { providers.Provider<unknown> }) -> Root,
	useLifecycle: (root: Root, lifecycle: lifecycles.Lifecycle) -> Root,
	useLifecycles: (root: Root, lifecycles: { lifecycles.Lifecycle }) -> Root,
	destroy: (root: Root) -> (),

	willStart: (callback: () -> ()) -> Root,
	willFinish: (callback: () -> ()) -> Root,
}

export type StartedRoot = {
	type: "StartedRoot",

	finish: (root: StartedRoot) -> (),
}

export type Self = Root & {
	_destroyed: boolean,
	_rootProviders: Set<providers.Provider<unknown>>,
	_rootLifecycles: Set<lifecycles.Lifecycle>,
	_subRoots: Set<Root>,
	_start: lifecycles.Lifecycle<()>,
	_finish: lifecycles.Lifecycle<()>,
}

return nil
