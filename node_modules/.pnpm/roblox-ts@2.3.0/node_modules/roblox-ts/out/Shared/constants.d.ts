import { ProjectOptions } from "./types";
export declare const PACKAGE_ROOT: string;
export declare const INCLUDE_PATH: string;
export declare const COMPILER_VERSION: string;
export declare const NODE_MODULES = "node_modules";
export declare const RBXTS_SCOPE = "@rbxts";
export declare const TS_EXT = ".ts";
export declare const TSX_EXT = ".tsx";
export declare const D_EXT = ".d";
export declare const DTS_EXT: string;
export declare const INDEX_NAME = "index";
export declare const INIT_NAME = "init";
export declare const SERVER_SUBEXT = ".server";
export declare const CLIENT_SUBEXT = ".client";
export declare const MODULE_SUBEXT = "";
export declare const FILENAME_WARNINGS: Map<string, string>;
export declare const PARENT_FIELD = "Parent";
export declare enum ProjectType {
    Game = "game",
    Model = "model",
    Package = "package"
}
export declare const DEFAULT_PROJECT_OPTIONS: ProjectOptions;
