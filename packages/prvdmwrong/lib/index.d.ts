/*
  Copyright (c) Team Fireworks 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
 */

export = prvdmwrong
export as namespace prvdmwrong

// TODO: doc comments
declare namespace prvdmwrong {
	export enum StartupStatus {
		Pending = "StartupStatus.Pending",
		Starting = "StartupStatus.Starting",
		Started = "StartupStatus.Started",
	}

	export type Options = {
		logLevel: "none" | "verbose"
		profiling: boolean
	}

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
	export const awaitStart: () => void
	export const onStart: (callback: () => void) => void
	export const preload: (instances: Instance[], predicate?: (module: ModuleScript) => boolean) => unknown[]
	export const Provider: (options?: {
		loadOrder?: number
	}) => <T extends new () => InstanceType<T>>(provider: T) => void
	export const start: (options?: Partial<Options>) => void
	export const use: <T extends new () => InstanceType<T>>(provider: T) => InstanceType<T>

	export class Lifecycle<Interface extends object = object> {
		constructor(method: string, fire: (lifecycle: Lifecycle, ...args: unknown[]) => void)

		public listeners: Interface[]
		readonly method: string

		public fire(...args: unknown[]): void
		public register(object: Interface): void
		public unregister(object: Interface): void
	}
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

		export const registerDependency: (identifier: string, dependency: object) => void
	}
}
