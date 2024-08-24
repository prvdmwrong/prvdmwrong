/*
 * Copyright 2024 Team Fireworks
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the “Software”), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import { type Lifecycle } from "@prvdmwrong/core"

export = Lifecycles
export as namespace Lifecycles
declare namespace Lifecycles {
	/**
	 * Hook onto the onPreSimulation lifecycle method. Equivalent to the
	 * RunService.PreSimulation event.
	 */
	export interface OnPreSimulation {
		/**
		 * Runs every frame before physic simulation.
		 */
		onPreSimulation(dt: number): void
	}

	/**
	 * Hook onto the onPreSimulation lifecycle method. Equivalent to the
	 * RunService.PostSimulation event.
	 */
	export interface OnPostSimulation {
		/**
		 * Runs every frame after physic simulation.
		 */
		onPostSimulation(dt: number): void
	}

	/**
	 * Hook onto the onPreAnimation lifecycle method. Equivalent to the
	 * RunService.PreAnimation event.
	 */
	export interface OnPreAnimation {
		/**
		 * Runs every prior to the physics simulation but after rendering. Only runs
		 * on the client.
		 */
		onPreAnimation(dt: number): void
	}

	/**
	 * Hook onto the onPreRender lifecycle method. Equivalent to the
	 * RunService.PreRender event.
	 */
	export interface OnPreRender {
		/**
		 * Runs every frame before rendering. Only runs on the client.
		 */
		onPreRender(dt: number): void
	}

	/**
	 * Hook onto the onShutdown lifecycle method. Equivalent to game:BindToClose or
	 * the plugin.Unloading event for plugins.
	 */
	export interface OnShutdown {
		/**
		 * Runs just before the game or plugin shuts down.
		 */
		onShutdown(): void
	}

	/**
	 * Hook onto the onPlayerAdded lifecycle method. Equivalent to the
	 * Players.PlayerAdded event.
	 */
	export type OnPlayerAdded = {
		/**
		 * Runs when a player joined and for every existing player prior to startup.
		 */
		onPlayerAdded(player: Player): void
	}

	/**
	 * Hook onto the onPlayerRemoving lifecycle method. Equivalent to the
	 * Players.PlayerRemoved event.
	 */
	export type OnPlayerRemoving = {
		/**
		 * Runs just before a player leaves the game.
		 */
		onPlayerRemoving(player: Player): void
	}

	export const preSimulation: Lifecycle<OnPreSimulation>
	export const postSimulation: Lifecycle<OnPostSimulation>
	export const preAnimation: Lifecycle<OnPreAnimation>
	export const preRender: Lifecycle<OnPreRender>
	export const shutdown: Lifecycle<OnShutdown>
	export const playerAdded: Lifecycle<OnPlayerAdded>
	export const playerRemoving: Lifecycle<OnPlayerRemoving>
}
