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
declare namespace ohmyprvd {
	export type Provider<T extends object> = T & {
		readonly load?: number

		init?(): void
		start?(): void
		heartbeat?(dt: number): void
		step?(dt: number): void
		render?(dt: number): void
	}
	export type Options = {
		loglevel: "none" | "verbose"
		profiling: boolean
	}

	export const version: string

	export enum IgnitionStatus {
		Pending = "IgnitionStatus.Pending",
		Ignition = "IgnitionStatus.Ignition",
		Ignited = "IgnitionStatus.Ignited",
	}

	export enum LoadMode {
		Children = "LoadMode.Children",
		Descendants = "LoadMode.Descendants",
	}

	export const awaitIgnition: () => void
	export const ignite: (options?: Partial<Options>) => void
	export const onIgnition: (callback: () => void) => void
	export const register: <T extends object>(name: string, provider: Provider<T>) => Provider<T>
	export const preloadProviders: (
		parent: Instance,
		predicate?: (module: ModuleScript) => boolean,
		loadMode?: LoadMode,
	) => unknown[]
	export const use: <T extends object>(provider: Provider<T>) => T

	export interface Init {
		init(): void | Promise<void>
	}

	export interface Start {
		start(): void
	}

	export interface Heartbeat {
		heartbeat(dt: number): void
	}

	export interface Step {
		step(dt: number): void
	}

	export interface Render {
		render(dt: number): void
	}
}
