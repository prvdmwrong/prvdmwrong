export = Prvd
export as namespace Prvd
declare namespace Prvd {
    type Cleanup = () => void

    export interface OnInit {
        onInit(): void
    }

    export interface OnStart {
        onStart(): void
    }

    export interface OnStop {
        onStop(): void
    }

    export type Provider<Self extends object> = Self & {
        loadOrder?: number
        name?: string

        onInit?(): void
        onStart?(): void
        onStop?(): void
    }

    export interface Lifecycle<Args extends unknown[]> {
        callbacks: Array<(...args: Args) => void>
        method: string

        register(callback: (...args: Args) => void): void
        fire(...args: Args): void
        unregister(callback: (...args: Args) => void): void
        unregisterAll(): void
        onRegistered(listener: (callback: (...args: Args) => void) => void): Cleanup
        onUnregistered(listener: (callback: (...args: Args) => void) => void): Cleanup
        destroy(): void
    }

    export interface Root {
        rootProviders: Set<Provider<object>>
        start(): StartRoot

        useModule(module: ModuleScript): Root
        useModules(modules: Instance[]): Root
        useRoot(root: Root): Root
        useRoots(root: Root[]): Root
        useProvider(provider: Provider<object>): Root
        useProviders(provider: Provider<object>[]): Root
        useLifecycle(lifecycle: Lifecycle<unknown[]>): Root
        useLifecycles(lifecycle: Lifecycle<unknown[]>[]): Root

        onInit: Lifecycle<[]>
        onStart: Lifecycle<[]>
        onStop: Lifecycle<[]>
    }

    export interface StartRoot {
        status(): RootStatus
    }

    export enum RootStatus {
        Pending = "RootStatus.Pending",
        Starting = "RootStatus.Starting",
        Started = "RootStatus.Started"
    }

    export const version: string

    export const root: Root
    export const Provider: <Self extends new () => InstanceType<Self>>(provider: Self) => void
    export const onProviderConstructed: (listener: (provider: Provider<object>) => void) => Cleanup

    export const lifecycle: <Args extends unknown[] = unknown[]>(
        method: string,
        onFire: (lifecycle: Lifecycle<Args>, ...args: Args) => void
    ) => Lifecycle<Args>
    export const fireConcurrent: <Args extends unknown[] = unknown[]>(lifecycle: Lifecycle<Args>, ...args: Args) => void
    export const fireSequential: <Args extends unknown[] = unknown[]>(lifecycle: Lifecycle<Args>, ...args: Args) => void
    export const onLifecycleRegistered: (
        listener: (lifecycle: Lifecycle<unknown[]>, ...args: unknown[]) => void
    ) => Cleanup
    export const onLifecycleUnregistered: (
        listener: (lifecycle: Lifecycle<unknown[]>, ...args: unknown[]) => void
    ) => Cleanup
    export const onLifecycleDestroying: (listener: (lifecycle: Lifecycle<unknown[]>) => void) => Cleanup

    export const netRoot: Root

    export const componentRoot: Root
}
