export declare function createReadBuildProgramHost(): {
    getCurrentDirectory: () => string;
    readFile: (path: string, encoding?: string | undefined) => string | undefined;
    useCaseSensitiveFileNames: () => boolean;
};
