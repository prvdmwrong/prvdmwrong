export type Lifecycle<Args... = ...any> = {
	type: "Lifecycle",

	callbacks: { (Args...) -> () },
	method: string,

	register: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
	fire: (self: Lifecycle<Args...>, Args...) -> (),
	unregister: (self: Lifecycle<Args...>, callback: (Args...) -> ()) -> (),
	unregisterAll: (self: Lifecycle<Args...>) -> (),
	onRegistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
	onUnregistered: (self: Lifecycle<Args...>, listener: (callback: (Args...) -> ()) -> ()) -> () -> (),
	await: (self: Lifecycle<Args...>) -> Args...,
	destroy: (self: Lifecycle<Args...>) -> (),
}

export type Self<Args... = ...any> = Lifecycle<Args...> & {
	_isDestroyed: boolean,
	_selfRegistered: { (callback: (Args...) -> ()) -> () },
	_selfUnregistered: { (callback: (Args...) -> ()) -> () },
}

return nil
