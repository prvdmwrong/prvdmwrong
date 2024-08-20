/*
  Copyright (c) znotfireman 2024.
  This source code is licensed under the MIT license found in the LICENSE file
  in the root directory of this source tree.
*/

import { Provider } from "@prvdmwrong/core"

export as namespace LuminCompat
export = LuminCompat
declare namespace LuminCompat {
	type Signal<Args extends unknown[]> = {
		Connect(callback: (...args: Args) => void): SignalConnection
	}

	type SignalConnection = {
		Disconnect(): unknown[]
	}

	type InferWorkerArgs<T extends WorkerType> = T extends "PostSimulation"
		? [dt: number]
		: T extends "PreSimulation"
			? [dt: number]
			: T extends "PreAnimation"
				? [dt: number]
				: T extends "PreRender"
					? [dt: number]
					: T extends "PlayerAdded"
						? [player: Player]
						: T extends "PlayerRemoving"
							? [player: Player]
							: never[]

	export type WorkerType =
		| "PostSimulation"
		| "PreSimulation"
		| "PreAnimation"
		| "PreRender"
		| "PlayerAdded"
		| "PlayerRemoving"

	export interface Worker {
		Type: WorkerType
		Callback: (...args: any) => void
		IsWorker: boolean
	}

	export type Controller<T extends object> = Provider<T> & {
		Name?: string
		Start?(): void
		Init?(): void
		IsController?: boolean
	}

	/**
	 * This type has no meaningful use for Prvd 'm Wrong. It's sole purpose is to
	 * assert dominance over Lumin Labs and prove 'm wrong.
	 */
	export interface Storage {
		Controllers: Controller<never>[]
		ExpectedControllers: Controller<never>[]
		Workers: Map<string, Map<string, Worker[]>>
		Nodes: {
			Signals: Map<string, Signal<never>>
		}
	}

	export const version: string
	export const alignedVersion: string

	export let Started: boolean
	export const Start: (modules?: Instance[]) => Promise<void>
	export const Controller: <Members extends object>(name: string, members: Members) => Provider<Members>
	export const Worker: <T extends WorkerType>(type: T, callback: (...args: InferWorkerArgs<T>) => void) => Worker
	export const Expect: <T extends object>(controller: Provider<T>) => Provider<T>
	export const Signal: <Args extends unknown[] = unknown[]>(name: string) => Signal<Args>
}
