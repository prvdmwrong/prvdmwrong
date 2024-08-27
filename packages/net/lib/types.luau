--!strict
--!nolint LocalShadow
-- Prvd 'M Wrong code licensed under MIT

export type Typeguard =
	-- literal type strings
	string
	-- t-style typeguard
	| (unknown) -> (boolean, ...unknown)

export type Middleware = {
	type: "Middleware",
	run: (self: Middleware, NetEvent | NetAsync) -> (Player, ...unknown) -> boolean,
}

export type Builder = {
	type: "NetEvent" | "NetFunction",
	returns: (self: Builder, ...Typeguard) -> Builder,
	middleware: (self: Builder, ...Middleware) -> Builder,
	unreliable: (self: Builder) -> Builder,
}

export type NetEvent<Args... = ...unknown> = ToServer<Args...> & ToClient<Args...>
export type NetAsync<Args... = ...unknown, Returns... = ...unknown> =
	ClientAsync<Args..., Returns...>
	& ServerAsync<Args..., Returns...>

--[=[
  A network event that is called on the client and processed on the server.
]=]
export type ToServer<Args... = ...unknown> = {
	type: "NetEvent",
	name: string,

	connect: (self: ToServer<Args...>, callback: (player: Player, Args...) -> ()) -> RBXScriptConnection,
	disconnectAll: (self: ToServer<Args...>) -> (),

	fire: (self: ToServer<Args...>, Args...) -> (),
	destroy: (self: ToServer<Args...>) -> (),
}

--[=[
  A network event that is called on the server and processed on the client.
]=]
export type ToClient<Args... = ...unknown> = {
	type: "NetEvent",
	name: string,

	connect: (self: ToClient<Args...>, callback: (Args...) -> ()) -> RBXScriptConnection,
	destroy: (self: ToClient<Args...>) -> (),
	disconnectAll: (self: ToClient<Args...>) -> (),

	fire: (self: ToClient<Args...>, player: Player, Args...) -> (),
	firePlayers: (self: ToClient<Args...>, players: { Player }, Args...) -> (),
	fireAll: (self: ToClient<Args...>, Args...) -> (),
}

--[=[
  A network function that is processed on the client.

  @deprecated Invoking a client has serious risks as noted by [the Roblox
  documentation.](https://create.roblox.com/docs/scripting/events/remote#server-client-server)
]=]
export type ClientAsync<Args... = ...unknown, Returns... = ...unknown> = {
	type: "NetFunction",
	name: string,

	onInvoke: (self: ClientAsync<Args..., Returns...>, callback: (Args...) -> Returns...) -> (),
	invoke: (self: ClientAsync<Args..., Returns...>, player: Player, Args...) -> Returns...,
	destroy: (self: ClientAsync<Args..., Returns...>) -> (),
}

--[=[
  A network function that is processed on the server.
]=]
export type ServerAsync<Args... = ...unknown, Returns... = ...unknown> = {
	type: "NetFunction",
	name: string,

	onInvoke: (self: ServerAsync<Args..., Returns...>, callback: (player: Player, Args...) -> Returns...) -> (),
	invoke: (self: ServerAsync<Args..., Returns...>, Args...) -> Returns...,
	destroy: (self: ServerAsync<Args..., Returns...>) -> (),
}

return nil
