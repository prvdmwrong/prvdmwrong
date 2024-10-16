type Set<T> = { [T]: true }

export type Lifecycle<Args...> = {
	callbacks: { (Args...) -> () },
	method: string,
	type: "Lifecycle",

	register: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
	fire: (self: Lifecycle<Args...>, Args...) -> (),
	unregister: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
	unregisterAll: (self: Lifecycle<Args...>) -> (),
	onRegistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
	onUnregistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
	destroy: (self: Lifecycle<Args...>) -> (),
}

--[=[
    @within Prvd
    @interface Provider<Self>

    Provider are objects that *provide* specific functions to a game. Providers
    can use lifecycles by specifying the lifecycle's method. Providers can be
    started using a root, which is a starting point for Prvd 'M Wrong games.

    .loadOrder number? -- Wow
    .name string? -- Wow
    .onInit (self: Provider<Self>) -> ()? -- Wow
    .onStart (self: Provider<Self>) -> ()? -- Wow
    .onStop (self: Provider<Self>) -> ()? -- Wow
]=]
export type Provider<Self> = Self & {
	[ConstructedKey]: Provider<Self>,

	loadOrder: number?,
	name: string?,

	onInit: (self: Provider<Self>) -> ()?,
	onStart: (self: Provider<Self>) -> ()?,
	onStop: (self: Provider<Self>) -> ()?,
}

--[=[
    @within Prvd
    @interface StartRoot

    .useModule (self: Root, module: ModuleScript) -> Root -- Wow
    Pst. I see dead people.
]=]
export type StartedRoot = {
	stop: (root: StartedRoot) -> (),
}

export type Root = {
	_rootProviders: Set<Provider<unknown>>,
	_subRoots: Set<Root>,

	start: (root: Root) -> StartedRoot,
	status: RootStatus,

	useModule: (root: Root, module: ModuleScript) -> Root,
	useModules: (root: Root, modules: { Instance }, predicate: ((ModuleScript) -> boolean)?) -> Root,
	useRoot: (root: Root, root: Root) -> Root,
	useRoots: (root: Root, roots: { Root }) -> Root,
	useProvider: (root: Root, provider: Provider<unknown>) -> Root,
	useProviders: (root: Root, providers: { Provider<unknown> }) -> Root,
	useLifecycle: (root: Root, lifecycle: Lifecycle<...unknown>) -> Root,
	useLifecycles: (root: Root, lifecycles: { Lifecycle<...unknown> }) -> Root,

	onInit: Lifecycle<()>,
	onStart: Lifecycle<()>,
	onStop: Lifecycle<()>,
}

export type RootStatus = "RootStatus.Pending" | "RootStatus.Starting" | "RootStatus.Started" | "RootStatus.Stopped"

-- Required so TypeScript class decorators can properly register providers
export type ConstructedKey = {
	____phantom__constructedKey: never?,
}

return nil
