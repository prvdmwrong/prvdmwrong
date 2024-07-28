/*
 * Copyright 2024 Team Fireworks
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

export = ohmyprvd
export as namespace ohmyprvd

/**
 * Oh My Prvd is a delightful framework for next-generation Roblox game
 * development.
 */
declare namespace ohmyprvd {
	/**
	 * Configures how Oh My Prvd will ignite. The following are the available
	 * configuration options: This type is not useful outside of Oh My Prvd
	 * itself; prefer to specify ignition options as a parameter of
	 * `prvd.ignite(options)`
	 */
	export type Options = {
		loglevel: "none" | "verbose"
		profiling: boolean
	}

	/**
	 * Provides a specific functionality for a game. This type is not useful
	 * outside of Oh My Prvd itself; prefer to use `prvd.use(provider)` for more
	 * precise types.
	 */
	export type Provider<T extends object> = T & {
		readonly load?: number

		init?(): void | Promise<void>
		start?(): void
		heartbeat?(dt: number): void
		step?(dt: number): void
		render?(dt: number): void
	}

	/**
	 * An enumeration of all defined ignition status Oh My Prvd will be in.
	 *
	 * This enum is not useful outside of Oh My Prvd itself; prefer to work with
	 * `awaitIgnition()` and `onIgnition(callback)`
	 */
	export enum IgnitionStatus {
		/**
		 * Indicates that `prvd.ignite()` has not been called yet. Calls to
		 * prvd.use() and prvd.Provider() are safe.
		 */
		Pending = "IgnitionStatus.Pending",

		/**
		 * Indicates that `prvd.ignite()` has been called, but the ignition process
		 * has not finished. Calls to `prvd.use()` and `prvd.Provider()` will throw
		 * an error.
		 */
		Ignition = "IgnitionStatus.Ignition",

		/**
		 * Indicates that the ignition process has finished. Calls to `prvd.use()`
		 * and `prvd.Provider()` will throw an error.
		 *
		 * Awaiting threads from `prvd.awaitIgnition()` and queued callbacks from
		 * `prvd.onIgnition()` will be spawned just before the ignition status is
		 * set to this.
		 */
		Ignited = "IgnitionStatus.Ignited",
	}

	export const version: string

	/**
	 * Yields the calling thread just before ignition finishes. If Oh My Prvd has
	 * already started, the thread will continue.
	 */
	export const awaitIgnition: () => void

	/**
	 * Ignites Oh My Prvd. Expected to be called once in an environment, e.g. once
	 * on the server and once on the client.
	 *
	 * All necessary providers should be preloaded before calling this as newly
	 * created providers will not run its lifecycle events.
	 */
	export const ignite: (options?: Partial<Options>) => void

	/**
	 * Listen for when a provider implements a lifecycle method. Commonly used to
	 * implement custom lifecycles by adding providers to a "watchlist" which will
	 * have its methods fired.
	 */
	export const implementMethod: (
		method: string,
		handler: (provider: Provider<object>) => void,
	) => void

	/**
	 * Queues a callback to be called just before ignition finishes. If Oh My Prvd
	 * has already started, the callback will be spawned immediately.
	 */
	export const onIgnition: (callback: () => void) => void

	/**
	 * Constructs and returns a new provider within Oh My Prvd. Providers must be
	 * created before calling Prvd.ignite().
	 */
	export const Provider: <T extends object>(
		name: string,
		provider: Provider<T>,
	) => Provider<T>

	/**
	 * Uses a provider within Oh My Prvd. During ignition, Oh My Prvd will inject
	 * the dependencies your provider uses.
	 */
	export const use: <T extends object>(provider: Provider<T>) => T

	/**
	 * Preload the specified parent by requiring all ModuleScripts within it. An
	 * optional predicate function can be provided to filter modules.
	 */
	export const loadChildren: (
		parent: Instance,
		predicate?: (module: ModuleScript) => boolean,
	) => unknown[]

	/**
	 * Preload the specified parent by requiring all ModuleScripts within it
	 * recursively. An optional predicate function can be provided to filter
	 * modules.
	 */
	export const loadDescendants: (
		parent: Instance,
		predicate?: (module: ModuleScript) => boolean,
	) => unknown[]
}
