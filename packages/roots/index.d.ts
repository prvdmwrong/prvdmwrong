import { Lifecycle } from "../lifecycles";
import { Provider } from "../providers";

declare namespace roots {
	export type Root = {
		type: "Root";

		start(): StartedRoot;

		useModule(module: ModuleScript): Root;
		useModules(modules: Instance[], predicate?: (module: ModuleScript) => boolean): Root;
		useRoot(root: Root): Root;
		useRoots(roots: Root[]): Root;
		useProvider(provider: Provider<any, any>): Root;
		useProviders(providers: Provider<any, any>[]): Root;
		useLifecycle(lifecycle: Lifecycle): Root;
		useLifecycles(lifecycles: Lifecycle): Root;
		destroy(): void;

		willStart(callback: () => void): Root;
		willFinish(callback: () => void): Root;
	};

	export type StartedRoot = {
		type: "StartedRoot";

		finish(): void;
	};

	export function create(): Root;

	export namespace hooks {
		export function onLifecycleUsed(listener: (lifecycle: Lifecycle) => void): () => void;
		export function onProviderUsed(listener: (provider: Provider<any, any>) => void): () => void;
		export function onRootUsed(listener: (root: Root, subRoot: Root) => void): () => void;

		export function onRootConstructing(listener: (root: Root) => void): () => void;
		export function onRootStarted(listener: (root: Root) => void): () => void;
		export function onRootFinished(listener: (root: Root) => void): () => void;
		export function onRootDestroyed(listener: (root: Root) => void): () => void;
	}
}

export = roots;
export as namespace roots;
