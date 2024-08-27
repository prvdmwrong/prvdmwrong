/*
  (c) Prvd 'M Wrong, dual-licensed under MIT or Apache 2.0 terms.
*/

declare interface SignalNode<T> {
	Next?: SignalNode<T>
	Callback: (this: SignalNode<T>, Value: T) => void
}

declare interface Signal<T> {
	Root?: SignalNode<T>

	Connect(this: Signal<T>, Callback: (Value: T) => void): () => void
	Wait(this: Signal<T>): T
	Once(this: Signal<T>, Callback: (Value: T) => void): () => void
	Fire(this: Signal<T>, Value: T): void
	DisconnectAll(this: Signal<T>): void
}

export interface singleton {
	identifier?: string
	priority?: number
	init?(): void
	start?(): void
	[key: string]: any
}

export interface extension {
	identifier: string
	extension(sapphire: SapphireObject): void
	methods?: Map<string, (singleton: singleton) => void>

	[key: string]: any
}

declare interface SapphireObject {
	signals: {
		on_extension_registered: Signal<extension>
		on_singleton_registered: Signal<singleton>
		on_singleton_initialized: Signal<singleton>
		on_singleton_started: Signal<singleton>
	}

	use(this: SapphireObject, extension: extension): SapphireObject
	register_singleton(this: SapphireObject, mod: ModuleScript): SapphireObject
	register_singletons(this: SapphireObject, container: Folder): SapphireObject
	start(this: SapphireObject): void
}

export as namespace sapphire
declare interface sapphire {
	(): SapphireObject
}
