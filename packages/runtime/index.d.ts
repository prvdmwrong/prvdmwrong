declare namespace runtime {
	export type RuntimeName = "roblox" | "luau" | "lune" | "lute" | "seal" | "zune";

	export const name: RuntimeName;

	export namespace task {
		export function cancel(thread: thread): void;

		export function defer<T extends unknown[]>(functionOrThread: (...args: T) => void, ...args: T): thread;
		export function defer(functionOrThread: thread): thread;
		export function defer<T extends unknown[]>(
			functionOrThread: thread | ((...args: T) => void),
			...args: T
		): thread;

		export function delay<T extends unknown[]>(
			duration: number,
			functionOrThread: (...args: T) => void,
			...args: T
		): thread;
		export function delay(duration: number, functionOrThread: thread): thread;
		export function delay<T extends unknown[]>(
			duration: number,
			functionOrThread: thread | ((...args: T) => void),
			...args: T
		): thread;

		export function spawn<T extends unknown[]>(functionOrThread: (...args: T) => void, ...args: T): thread;
		export function spawn(functionOrThread: thread): thread;
		export function spawn<T extends unknown[]>(
			functionOrThread: thread | ((...args: T) => void),
			...args: T
		): thread;

		export function wait(duration: number): number;
	}

	export function warn<T extends unknown[]>(...args: T): void;

	export namespace threadpool {
		export function spawn<T extends unknown[]>(f: (...args: T) => void, ...args: T): void;
		export function spawnCallbacks<T extends unknown[]>(functions: ((...args: T) => void)[], ...args: T): void;
	}
}

export = runtime;
export as namespace runtime;
