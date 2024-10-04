"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.tryRemoveOutput = void 0;
const fs_extra_1 = __importDefault(require("fs-extra"));
const LogService_1 = require("../../Shared/classes/LogService");
const constants_1 = require("../../Shared/constants");
function isOutputFileOrphaned(pathTranslator, filePath) {
    if (filePath.endsWith(constants_1.DTS_EXT) && !pathTranslator.declaration) {
        return true;
    }
    for (const path of pathTranslator.getInputPaths(filePath)) {
        if (fs_extra_1.default.pathExistsSync(path)) {
            return false;
        }
    }
    if (pathTranslator.buildInfoOutputPath === filePath) {
        return false;
    }
    return true;
}
function tryRemoveOutput(pathTranslator, outPath) {
    if (isOutputFileOrphaned(pathTranslator, outPath)) {
        fs_extra_1.default.removeSync(outPath);
        LogService_1.LogService.writeLineIfVerbose(`remove ${outPath}`);
    }
}
exports.tryRemoveOutput = tryRemoveOutput;
//# sourceMappingURL=tryRemoveOutput.js.map