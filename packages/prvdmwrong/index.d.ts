import dependencies from "../dependencies";
import lifecycles from "../lifecycles";
import providers from "../providers";
import roots from "../roots";

declare namespace prvd {
	export type Provider<Self, Dependencies = undefined> = providers.Provider<Self, Dependencies>;
	export interface Lifecycle<Args extends unknown[] = unknown[]> extends lifecycles.Lifecycle<Args> {}
	export type SubdependenciesOf<T> = dependencies.SubdependenciesOf<T>;
	export interface Root extends roots.Root {}
	export interface StartedRoot extends roots.StartedRoot {}

	export interface Start extends providers.Start {}
	export interface Destroy extends providers.Destroy {}

	export const provider: typeof providers.create;
	export const root: typeof roots.create;
	export const depend: typeof dependencies.depend;
	export const priority: typeof dependencies.priority;
	export const subdependencies: typeof dependencies.subdependencies;

	export const lifecycle: typeof lifecycles.create;
	export const fireConcurrent: typeof lifecycles.handlers.fireConcurrent;
	export const fireSequential: typeof lifecycles.handlers.fireSequential;

	export namespace hooks {
		export const onLifecycleConstructed: typeof lifecycles.hooks.onLifecycleConstructed;
		export const onLifecycleDestroyed: typeof lifecycles.hooks.onLifecycleDestroyed;
		export const onLifecycleRegistered: typeof lifecycles.hooks.onLifecycleRegistered;
		export const onLifecycleUnregistered: typeof lifecycles.hooks.onLifecycleUnregistered;

		export const onLifecycleUsed: typeof roots.hooks.onLifecycleUsed;
		export const onProviderUsed: typeof roots.hooks.onProviderUsed;
		export const onRootUsed: typeof roots.hooks.onRootUsed;
		export const onRootConstructing: typeof roots.hooks.onRootConstructing;
		export const onRootStarted: typeof roots.hooks.onRootStarted;
		export const onRootFinished: typeof roots.hooks.onRootFinished;
		export const onRootDestroyed: typeof roots.hooks.onRootDestroyed;
	}
}

export = prvd;
export as namespace prvd;
