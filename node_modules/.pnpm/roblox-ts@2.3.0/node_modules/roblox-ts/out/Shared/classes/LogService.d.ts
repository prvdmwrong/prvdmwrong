export declare class LogService {
    static verbose: boolean;
    private static partial;
    static write(message: string): void;
    static writeLine(...messages: Array<unknown>): void;
    static writeLineIfVerbose(...messages: Array<unknown>): void;
    static warn(message: string): void;
    static fatal(message: string): never;
}
