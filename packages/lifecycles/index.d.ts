declare namespace lifecycles {
	export interface Lifecycle<Args extends unknown[] = unknown[]> {
		type: "Lifecycle";

		callbacks: Array<(...args: Args) => void>;
		method: string;

		register(callback: (...args: Args) => void): void;
		fire(...args: Args): void;
		unregister(callback: (...args: Args) => void): void;
		clear(): void;
		onRegistered(listener: (callback: (...args: Args) => void) => void): () => void;
		onUnegistered(listener: (callback: (...args: Args) => void) => void): () => void;
		await(): LuaTuple<Args>;
		destroy(): void;
	}

	export function create<Args extends unknown[]>(
		method: string,
		onFire: (lifecycle: Lifecycle<Args>, ...args: Args) => void
	): Lifecycle<Args>;

	export namespace handlers {
		export function fireConcurrent<Args extends unknown[]>(lifecycle: Lifecycle<Args>, ...args: Args): void;
		export function fireSequential<Args extends unknown[]>(lifecycle: Lifecycle<Args>, ...args: Args): void;
	}

	export namespace hooks {
		export function onLifecycleConstructed(callback: (lifecycle: Lifecycle) => void): () => void;
		export function onLifecycleDestroyed(callback: (lifecycle: Lifecycle) => void): () => void;
		export function onLifecycleRegistered<Args extends unknown[]>(
			callback: (lifecycle: Lifecycle<Args>, callback: (...args: Args) => void) => void
		): () => void;
		export function onLifecycleUnregistered<Args extends unknown[]>(
			callback: (lifecycle: Lifecycle<Args>, callback: (...args: Args) => void) => void
		): () => void;
	}

	export namespace _ {
		export const methodToLifecycles: Map<string, Lifecycle>;
	}
}

export = lifecycles;
export as namespace lifecycles;
