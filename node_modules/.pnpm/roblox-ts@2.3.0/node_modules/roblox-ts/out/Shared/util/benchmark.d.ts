export declare function benchmarkSync(name: string, callback: () => void): void;
export declare function benchmarkIfVerbose(name: string, callback: () => void): void;
export declare function benchmark<T>(name: string, callback: () => Promise<T>): Promise<void>;
