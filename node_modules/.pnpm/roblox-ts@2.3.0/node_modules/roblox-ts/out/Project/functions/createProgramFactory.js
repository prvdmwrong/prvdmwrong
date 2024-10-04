"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createProgramFactory = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const createReadBuildProgramHost_1 = require("../util/createReadBuildProgramHost");
const constants_1 = require("../../Shared/constants");
const assert_1 = require("../../Shared/util/assert");
const typescript_1 = __importDefault(require("typescript"));
function createCompilerHost(data, compilerOptions) {
    var _a;
    const host = typescript_1.default.createIncrementalCompilerHost(compilerOptions);
    let contentsToHash = "";
    contentsToHash += `version=${constants_1.COMPILER_VERSION},`;
    contentsToHash += `type=${String(data.projectOptions.type)},`;
    contentsToHash += `isPackage=${String(data.isPackage)},`;
    contentsToHash += `plugins=${JSON.stringify((_a = compilerOptions.plugins) !== null && _a !== void 0 ? _a : [])},`;
    if (data.rojoConfigPath && fs_extra_1.default.existsSync(data.rojoConfigPath)) {
        contentsToHash += fs_extra_1.default.readFileSync(data.rojoConfigPath).toString();
    }
    (0, assert_1.assert)(host.createHash);
    const origCreateHash = host.createHash;
    host.createHash = (data) => origCreateHash(contentsToHash + data);
    return host;
}
function createProgramFactory(data, options) {
    return (rootNames, compilerOptions = options, host = createCompilerHost(data, options), oldProgram = typescript_1.default.readBuilderProgram(options, (0, createReadBuildProgramHost_1.createReadBuildProgramHost)())) => typescript_1.default.createEmitAndSemanticDiagnosticsBuilderProgram(rootNames, compilerOptions, host, oldProgram);
}
exports.createProgramFactory = createProgramFactory;
//# sourceMappingURL=createProgramFactory.js.map