"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createProjectData = void 0;
const rojo_resolver_1 = require("@roblox-ts/rojo-resolver");
const fs_extra_1 = __importDefault(require("fs-extra"));
const path_1 = __importDefault(require("path"));
const LogService_1 = require("../../Shared/classes/LogService");
const constants_1 = require("../../Shared/constants");
const ProjectError_1 = require("../../Shared/errors/ProjectError");
const typescript_1 = __importDefault(require("typescript"));
const PACKAGE_REGEX = /^@[a-z0-9-]*\//;
function createProjectData(tsConfigPath, projectOptions) {
    var _a;
    const projectPath = path_1.default.dirname(tsConfigPath);
    const pkgJsonPath = typescript_1.default.findPackageJson(projectPath, typescript_1.default.sys);
    if (!pkgJsonPath) {
        throw new ProjectError_1.ProjectError("Unable to find package.json");
    }
    let isPackage = false;
    try {
        const pkgJson = JSON.parse(fs_extra_1.default.readFileSync(pkgJsonPath).toString());
        isPackage = PACKAGE_REGEX.test((_a = pkgJson.name) !== null && _a !== void 0 ? _a : "");
    }
    catch (e) {
    }
    projectOptions.includePath = path_1.default.resolve(projectOptions.includePath || path_1.default.join(projectPath, "include"));
    const nodeModulesPath = path_1.default.join(path_1.default.dirname(pkgJsonPath), constants_1.NODE_MODULES);
    let rojoConfigPath;
    if (projectOptions.rojo) {
        rojoConfigPath = path_1.default.resolve(projectOptions.rojo);
    }
    else {
        const { path, warnings } = rojo_resolver_1.RojoResolver.findRojoConfigFilePath(projectPath);
        rojoConfigPath = path;
        for (const warning of warnings) {
            LogService_1.LogService.warn(warning);
        }
    }
    return {
        tsConfigPath,
        isPackage,
        nodeModulesPath,
        projectOptions,
        projectPath,
        rojoConfigPath,
    };
}
exports.createProjectData = createProjectData;
//# sourceMappingURL=createProjectData.js.map