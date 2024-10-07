local Lifecycles = require("core/lifecycles")

export type Provider<Self> = Self & {
  loadOrder: number?,
  name: string?,

  onInit: (self: Provider<Self>) -> ()?,
  onStart: (self: Provider<Self>) -> ()?,
  onStop: (self: Provider<Self>) -> ()?,
}

export type StartRoot = {
  status: (self: StartRoot) -> RootStatus,
  stop: (self: StartRoot) -> (),
}

--[=[
  @within Providers
  @interface Root

  .useModule (self: Root, module: ModuleScript) -> Root -- Wow
  Fein
]=]
export type Root = {
  start: (self: Root) -> StartRoot,

  useModule: (self: Root, module: ModuleScript) -> Root,
  useModules: (self: Root, modules: { ModuleScript }) -> Root,
  useRoot: (self: Root, root: Root) -> Root,
  useRoots: (self: Root, roots: { Root }) -> Root,
  useProvider: (self: Root, provider: Provider<unknown>) -> Root,
  useProviders: (self: Root, providers: { Provider<unknown> }) -> Root,
  useLifecycle: (self: Root, lifecycle: Lifecycles.Lifecycle<...unknown>) -> Root,
  useLifecycles: (self: Root, lifecycles: { Lifecycles.Lifecycle<...unknown> }) -> Root,
}

--[=[
  @class Providers
  @since 0.1
  APIs for creating top level providers that *provide* specific functionality in
  a game, along with creating starting roots for using providers.
]=]
local Providers = {}

Providers.RootStatus = table.freeze {
  Pending = "RootStatus.Pending" :: "RootStatus.Pending",
  Starting = "RootStatus.Starting" :: "RootStatus.Starting",
  Started = "RootStatus.Started" :: "RootStatus.Started",
}

export type RootStatus = index<typeof(Providers.RootStatus), keyof<typeof(Providers.RootStatus)>>

--[=[
  Construct and returns a new provider. Providers *provide* specific functionality in a game.
  @param provider Self -- The provider and associated properties itself.
  @return Provider<Self> -- A newly constructed provider.
]=]
function Providers.prvd<Self>(provider: Self): Provider<Self>
  error("not implemented")
end

--[=[
  Construct and returns a new root. Roots are starting points for Prvd 'M Wrong games where providers can be bootstrapped.
  @return Root -- A newly constructed root.
]=]
function Providers.root(): Root
  error("not implemented")
end

return Providers
