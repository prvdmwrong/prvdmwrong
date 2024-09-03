--!strict
-- (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.

export type Error = {
	type: "Error",
	raw: string,
	message: string,
	trace: string,
}

export type OnInit = { onInit: (self: unknown) -> () }
export type OnStart = { onStart: (self: unknown) -> () }
export type Lifecycle<Interface = { [any]: any }> = {
	listeners: { Interface },
	method: string,

	fire: (self: Lifecycle<Interface>, ...unknown) -> (),
	register: (self: Lifecycle<Interface>, object: Interface) -> (),
	unregister: (self: Lifecycle<Interface>, object: Interface) -> (),
}

export type StartupStatus = "StartupStatus.Pending" | "StartupStatus.Starting" | "StartupStatus.Started"

export type Options = {
	logLevel: "none" | "verbose",
	profiling: boolean,
}

export type Provider<T> = T & {
	loadOrder: number?,
	name: string?,

	onInit: (self: Provider<T>) -> ()?,
	onStart: (self: Provider<T>) -> ()?,
	[{ __PROVIDER_KEY__: never? }]: Provider<T>,
}

return nil
