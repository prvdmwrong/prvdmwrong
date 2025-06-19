import { Lifecycle } from "../lifecycles";
import { Symbol } from "../symbols";

declare namespace dependencies {
	export type Dependency<Self, Dependencies = undefined, NewArgs extends unknown[] = []> = Self &
		Record<typeof subdependencies, Dependencies> &
		Record<typeof priority, number | undefined> & {
			new (dependencies: Dependencies, ...args: NewArgs): Dependency<Self, Dependencies, NewArgs>;
		};

	interface ProccessDependencyResult {
		sortedDependencies: Dependency<any, any, any>[];
		lifecycles: Lifecycle<any>[];
	}

	export type SubdependenciesOf<T> = T extends Record<typeof subdependencies, infer Dependencies>
		? Dependencies
		: never;

	export const subdependencies: Symbol<"prvdmwrong.dependencies.subdependencies">;
	export const priority: Symbol<"prvdmwrong.dependencies.priority">;

	export function depend<T extends new () => InstanceType<T>>(dependency: T): InstanceType<T>;
	export function processDependencies(dependencies: Set<Dependency<any, any, any>>): ProccessDependencyResult;
	export function sortByPriority(dependencies: Dependency<any, any, any>[]): void;
}

export = dependencies;
export as namespace dependencies;
