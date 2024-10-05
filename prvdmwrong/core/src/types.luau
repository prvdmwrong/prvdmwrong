export type Provider<Self> = Self & {
  loadOrder: number?,
  name: string?,

  onInit: (self: Provider<Self>) -> ()?,
  onStart: (self: Provider<Self>) -> ()?,
  onStop: (self: Provider<Self>) -> ()?,
}

export type Lifecycle<Args...> = {
  callbacks: { (Args...) -> () },
  register: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
  fire: (self: Lifecycle<Args...>, Args...) -> (),
  unregister: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
  unregisterAll: (self: Lifecycle<Args...>) -> (),
  onRegistered: (self: Lifecycle<Args...>, listener: () -> ()) -> () -> (),
  onUnregistered: (self: Lifecycle<Args...>, listener: () -> ()) -> () -> (),
}

export type RootStatus = "RootStatus.Pending" | "RootStatus.Starting" | "RootStatus.Started"
export type StartRoot = {
  status: (self: StartRoot) -> RootStatus,
  stop: (self: StartRoot) -> (),
}

export type Root = {
  start: (self: Root) -> StartRoot,

  useModule: (self: Root, module: ModuleScript) -> Root,
  useModules: (self: Root, modules: { ModuleScript }) -> Root,
  useRoot: (self: Root, root: Root) -> Root,
  useRoots: (self: Root, roots: { Root }) -> Root,
  useProvider: (self: Root, provider: Provider<unknown>) -> Root,
  useProviders: (self: Root, providers: { Provider<unknown> }) -> Root,
  useLifecycle: (self: Root, lifecycle: Lifecycle<...unknown>) -> Root,
  useLifecycles: (self: Root, lifecycles: { Lifecycle<...unknown> }) -> Root,
}

return nil
