import { Dependency } from "../dependencies";

declare namespace providers {
	export type Provider<Self, Dependencies = undefined> = Dependency<
		Self & {
			__index: Provider<Self, Dependencies>;
			name?: string;
			constructor?(dependencies: Dependencies): void;
			start?(): void;
			destroy?(): void;
		},
		Dependencies
	>;

	export function create<Self>(self: Self): Provider<Self>;
	// Class decorator syntax
	export function create<Self extends new () => InstanceType<Self>>(self: Self): Provider<Self>;

	export namespace _ {
		export const providerClasses: Set<Provider<any, any>>;
	}

	export interface Start {
		start(): void;
	}

	export interface Destroy {
		destroy(): void;
	}
}

export = providers;
export as namespace providers;
