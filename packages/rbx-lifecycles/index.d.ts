import { Lifecycle } from "../lifecycles";
import { Provider } from "../providers";

declare namespace RbxLifecycles {
	export const RbxLifecycles: Provider<{
		preSimulation: Lifecycle<[dt: number]>;
		postSimulation: Lifecycle<[dt: number]>;
		preAnimation: Lifecycle<[dt: number]>;
		preRender: Lifecycle<[dt: number]>;
		playerAdded: Lifecycle<[player: Player]>;
		playerRemoving: Lifecycle<[player: Player]>;
	}>;

	export interface PreSimulation {
		preSimulation(dt: number): void;
	}

	export interface PostSimulation {
		postSimulation(dt: number): void;
	}

	export interface PreAnimation {
		preAnimation(dt: number): void;
	}

	export interface PreRender {
		preRender(dt: number): void;
	}

	export interface PlayerAdded {
		playerAdded(player: Player): void;
	}

	export interface PlayerRemoving {
		playerRemoving(player: Player): void;
	}
}

export = RbxLifecycles;
export as namespace RbxLifecycles;
