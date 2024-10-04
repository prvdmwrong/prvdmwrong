export type Provider<Provider> = Provider & {}

export type Root = {
  start: (self: Root) -> (),
  useModule: (self: Root, module: ModuleScript) -> Root,
  useModules: (self: Root, modules: { ModuleScript }) -> Root,
  useRoot: (self: Root, root: Root) -> Root,
  useRoots: (self: Root, roots: { Root }) -> Root,
  useProvider: (self: Root, provider: Provider<unknown>) -> Root,
  useProviders: (self: Root, providers: { Provider<unknown> }) -> Root,
  -- FIXME(znotfireman): throws recursive type error using Lifecycle<...unknown>
  useLifecycle: (self: Root, lifecycle: unknown) -> Root,
  useLifecycles: (self: Root, lifecycles: { unknown }) -> Root,
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

export type PrvdNamespace = {
  root: () -> Root,

  lifecycle: <Args...>(fireHandler: (self: Lifecycle<Args...>, Args...) -> ()) -> Lifecycle<Args...>,
  fireConcurrent: <Args...>(self: Lifecycle<Args...>, Args...) -> (),
  fireSequential: <Args...>(self: Lifecycle<Args...>, Args...) -> (),
  onInit: Lifecycle<Provider<unknown>>,
  onStart: Lifecycle<Provider<unknown>>,
  onStop: Lifecycle<Provider<unknown>>,

  net: {
    root: Root,
  },

  components: {
    root: Root,
  },
}

export type Prvd = typeof(setmetatable(
  {} :: PrvdNamespace,
  {} :: {
    __call: <Provider>(self: unknown, provider: Provider) -> Provider,
  }
))

return nil
