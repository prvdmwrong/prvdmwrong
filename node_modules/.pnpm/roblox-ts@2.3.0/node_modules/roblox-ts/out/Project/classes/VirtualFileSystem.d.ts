export declare const PATH_SEP = "/";
export declare function pathJoin(...parts: Array<string>): string;
export declare class VirtualFileSystem {
    private root;
    constructor();
    private getPathParts;
    writeFile(filePath: string, content: string): void;
    private get;
    readFile(filePath: string): string | undefined;
    fileExists(filePath: string): boolean;
    directoryExists(dirPath: string): boolean;
    getDirectories(dirPath: string): string[];
    getFilePaths(): string[];
}
