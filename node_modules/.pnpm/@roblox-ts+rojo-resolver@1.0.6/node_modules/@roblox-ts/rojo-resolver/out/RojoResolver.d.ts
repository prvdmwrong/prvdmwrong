interface RojoTreeProperty {
    Type: string;
    Value: unknown;
}
interface RojoTreeMetadata {
    $className?: string;
    $path?: string | {
        optional: string;
    };
    $properties?: Array<RojoTreeProperty>;
    $ignoreUnknownInstances?: boolean;
}
type RojoTree = RojoTreeMetadata & RojoTreeMembers;
interface RojoTreeMembers {
    [name: string]: RojoTree;
}
export declare enum RbxType {
    ModuleScript = 0,
    Script = 1,
    LocalScript = 2,
    Unknown = 3
}
export type RbxPath = ReadonlyArray<string>;
export type RelativeRbxPath = ReadonlyArray<string | RbxPathParent>;
interface PartitionInfo {
    rbxPath: RbxPath;
    fsPath: string;
}
export declare enum FileRelation {
    OutToOut = 0,
    OutToIn = 1,
    InToOut = 2,
    InToIn = 3
}
export declare enum NetworkType {
    Unknown = 0,
    Client = 1,
    Server = 2
}
export declare const RbxPathParent: unique symbol;
export type RbxPathParent = typeof RbxPathParent;
export declare class RojoResolver {
    static findRojoConfigFilePath(projectPath: string): {
        path: string | undefined;
        warnings: string[];
    };
    private warnings;
    private constructor();
    private warn;
    getWarnings(): ReadonlyArray<string>;
    static fromPath(rojoConfigFilePath: string): RojoResolver;
    static synthetic(basePath: string): RojoResolver;
    static fromTree(basePath: string, tree: RojoTree): RojoResolver;
    private rbxPath;
    private partitions;
    private filePathToRbxPathMap;
    private isolatedContainers;
    isGame: boolean;
    private parseConfig;
    private parseTree;
    private parsePath;
    private searchDirectory;
    getRbxPathFromFilePath(filePath: string): RbxPath | undefined;
    getRbxTypeFromFilePath(filePath: string): RbxType;
    private getContainer;
    getFileRelation(fileRbxPath: RbxPath, moduleRbxPath: RbxPath): FileRelation;
    isIsolated(rbxPath: RbxPath): boolean;
    getNetworkType(rbxPath: RbxPath): NetworkType;
    static relative(rbxFrom: RbxPath, rbxTo: RbxPath): RelativeRbxPath;
    getPartitions(): ReadonlyArray<PartitionInfo>;
}
export {};
