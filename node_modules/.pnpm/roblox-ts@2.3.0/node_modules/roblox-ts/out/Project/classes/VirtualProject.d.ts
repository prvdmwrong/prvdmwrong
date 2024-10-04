import { VirtualFileSystem } from "./VirtualFileSystem";
export declare class VirtualProject {
    private readonly data;
    readonly vfs: VirtualFileSystem;
    private readonly compilerOptions;
    private readonly rojoResolver;
    private readonly pkgRojoResolvers;
    private readonly compilerHost;
    private program;
    private typeChecker;
    private nodeModulesPathMapping;
    constructor();
    compileSource(source: string): string;
    setMapping(typings: string, main: string): void;
}
