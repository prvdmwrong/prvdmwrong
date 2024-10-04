export declare class Lazy<T> {
    private readonly getValue;
    private isInitialized;
    private value;
    constructor(getValue: () => T);
    get(): T;
    set(value: T): void;
}
