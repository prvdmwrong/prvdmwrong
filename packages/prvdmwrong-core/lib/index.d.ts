/*
  (c) Prvd 'M Wrong, dual-licensed under Apache 2.0 or MIT terms.
 */

export = prvdmwrong
export as namespace prvdmwrong

declare namespace prvdmwrong {
	/**
	 * An enumeration of all defined startup status Prvd 'M Wrong will be in.
	 *
	 * This enum is not useful outside of Prvd 'M Wrong itself; prefer to work
	 * with {@link awaitStart()} and {@link onStart()}
	 */
	export enum StartupStatus {
		/**
		 * Indicates that {@link start()} has not been called yet. Creating a
		 * provider is safe.
		 */
		Pending = "StartupStatus.Pending",

		/**
		 * Indicates that {@link start()} has been called, but the startup process has
		 * not finished. Attempting to create a provider will throw an error.
		 */
		Starting = "StartupStatus.Starting",

		/**
		 * Indicates that the startup process has finished. Attempting to create a
		 * provider will throw an error.
		 */
		Started = "StartupStatus.Started",
	}

	/**
	 * Configures how Prvd 'M Wrong will ignite. The following are the available
	 * configuration options: This type is not useful outside of Prvd 'M Wrong
	 * itself; prefer to specify startup options as a parameter of
	 * {@link start()}.
	 */
	export type Options = {
		/**
		 * Configures if Prvd 'M Wrong should log trace information to the console,
		 * defaults to `"none"`.
		 */
		logLevel: "none" | "verbose"

		/**
		 * Configures if built-in lifecycle events should be profiled with
		 * debug.setmemorycategory and debug.profilebegin, defaults to whether the
		 * current session is running in Roblox Studio.
		 */
		profiling: boolean
	}

	/**
	 * Provides a specific functionality for a game. This type is not useful
	 * outside of Prvd 'M Wrong itself; prefer to import providers directly for
	 * more precise types.
	 */
	export type Provider<T> = T & {
		loadOrder?: number
		name?: string

		onInit?(): void
		onStart?(): void
	}

	export interface OnInit {
		onInit(): void
	}

	export interface OnInit {
		onStart(): void
	}

	export const version: string

	/**
	 * Yields the calling thread just before startup finishes. If Prvd 'M Wrong
	 * has already started, the thread will continue.
	 */
	export const awaitStart: () => void
	/**
	 * Queues a callback to be called just before startup finishes. If Prvd 'M
	 * Wrong has already started, the callback will be spawned immediately.
	 */
	export const onStart: (callback: () => void) => void
	/**
	 * Preload the specified parent by requiring all ModuleScripts within it. An
	 * optional predicate function can be provided to filter modules.
	 */
	export const preload: (instances: Instance[], predicate?: (module: ModuleScript) => boolean) => unknown[]
	/**
	 * Returns a decorator that when applied to a TypeScript class registers it as
	 * a provider within Prvd 'M Wrong. Providers must be created before calling
	 * {@link start()}.
	 */
	export const Provider: (options?: {
		loadOrder?: number
	}) => <T extends new () => InstanceType<T>>(provider: T) => void
	/**
	 * Starts Prvd 'M Wrong. Expected to be called once in an environment, e.g.
	 * once on the server and once on the client.
	 *
	 * All necessary providers should be preloaded before calling this as newly
	 * created providers will not run its lifecycle events.
	 */
	export const start: (options?: Partial<Options>) => void

	/** @deprecated specify providers as a direct member to use it */
	export function use<T extends new () => InstanceType<T>>(this: void, provider: T): InstanceType<T>
	export function use<T extends object>(this: void, provider: Provider<T>): T

	export interface Lifecycle<Interface extends object = object> {
		listeners: Interface[]
		readonly method: string

		fire(...args: unknown[]): void
		register(object: Interface): void
		unregister(object: Interface): void
	}
	/**
	 * Constructs and returns a new lifecycle within Prvd 'M Wrong. Lifecycles are
	 * special event dispatchers that can hook onto a provider's method.
	 */
	export const Lifecycle: <Interface extends object = object>(
		method: string,
		fire: (lifecycle: Lifecycle<Interface>, ...args: unknown[]) => void,
	) => Lifecycle<Interface>
	export const fireConcurrent: (lifecycle: Lifecycle, ...args: unknown[]) => void
	export const fireSequential: (lifecycle: Lifecycle, ...args: unknown[]) => void
	export const onLifecycleRegistered: (method: string, handler: (listener: object) => void) => void
	export const onLifecycleUnregistered: (method: string, handler: (listener: object) => void) => void

	export const getStartupOptions: () => Options
	export const getStartupStatus: () => StartupStatus
	export const onProviderConstructed: (handler: Provider<object>) => void
	export const onProviderUsed: (handler: Provider<object>) => void

	export namespace internal {
		export const registerAll: (object: object) => void
		export const registerMethod: (object: object, method: string) => void
		export const unregisterMethod: (object: object, method: string) => void

		export const defineMetadata: (object: unknown, key: string, value: unknown) => void
		export const getMetadata: (object: unknown, key: string) => unknown | undefined
		export const deleteMetadata: (object: unknown, key: string) => void

		export const registerDependency: (dependency: object) => void
	}
}
