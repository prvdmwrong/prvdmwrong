"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createPathTranslator = void 0;
const path_translator_1 = require("@roblox-ts/path-translator");
const path_1 = __importDefault(require("path"));
const findAncestorDir_1 = require("../../Shared/util/findAncestorDir");
const getRootDirs_1 = require("../../Shared/util/getRootDirs");
const typescript_1 = __importDefault(require("typescript"));
function createPathTranslator(program) {
    const compilerOptions = program.getCompilerOptions();
    const rootDir = (0, findAncestorDir_1.findAncestorDir)([program.getProgram().getCommonSourceDirectory(), ...(0, getRootDirs_1.getRootDirs)(compilerOptions)]);
    const outDir = compilerOptions.outDir;
    let buildInfoPath = typescript_1.default.getTsBuildInfoEmitOutputFilePath(compilerOptions);
    if (buildInfoPath !== undefined) {
        buildInfoPath = path_1.default.normalize(buildInfoPath);
    }
    const declaration = compilerOptions.declaration === true;
    return new path_translator_1.PathTranslator(rootDir, outDir, buildInfoPath, declaration);
}
exports.createPathTranslator = createPathTranslator;
//# sourceMappingURL=createPathTranslator.js.map