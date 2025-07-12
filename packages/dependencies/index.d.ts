import { Lifecycle } from "../lifecycles";

declare namespace dependencies {
	export type Dependency<Self, Dependencies = undefined, NewArgs extends unknown[] = []> = Self & {
		dependencies: Dependencies,
		priority?: number,
		new(dependencies: Dependencies, ...args: NewArgs): Dependency<Self, Dependencies, NewArgs>;
	};

	interface ProccessDependencyResult {
		sortedDependencies: Dependency<any, any, any>[];
		lifecycles: Lifecycle<any>[];
	}

	export type SubdependenciesOf<T> = T extends { dependencies: infer Dependencies }
		? Dependencies
		: never;

	export function depend<T extends new () => InstanceType<T>>(dependency: T): InstanceType<T>;
	export function processDependencies(dependencies: Set<Dependency<any, any, any>>): ProccessDependencyResult;
	export function sortByPriority(dependencies: Dependency<any, any, any>[]): void;
}

export = dependencies;
export as namespace dependencies;
