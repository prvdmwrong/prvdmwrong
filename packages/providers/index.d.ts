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

	// Class decorator syntax
	export function create<Self extends new () => InstanceType<Self>>(self: Self): Provider<Self>;
	// Normal syntax
	export function create<Self extends object>(self: Self): Provider<Self>;

	export function nameOf(provider: Provider<any, any>): string;

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
