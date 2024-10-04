"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkRojoConfig = void 0;
const path_1 = __importDefault(require("path"));
const diagnostics_1 = require("../../Shared/diagnostics");
const isPathDescendantOf_1 = require("../../Shared/util/isPathDescendantOf");
const DiagnosticService_1 = require("../../TSTransformer/classes/DiagnosticService");
function checkRojoConfig(data, rojoResolver, rootDirs, pathTranslator) {
    if (data.rojoConfigPath !== undefined) {
        for (const partition of rojoResolver.getPartitions()) {
            for (const rootDir of rootDirs) {
                if ((0, isPathDescendantOf_1.isPathDescendantOf)(partition.fsPath, rootDir)) {
                    const rojoConfigDir = path_1.default.dirname(data.rojoConfigPath);
                    const outPath = pathTranslator.getOutputPath(partition.fsPath);
                    const inputPath = path_1.default.relative(rojoConfigDir, partition.fsPath);
                    const suggestedPath = path_1.default.relative(rojoConfigDir, outPath);
                    DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.rojoPathInSrc(inputPath, suggestedPath));
                }
            }
        }
    }
}
exports.checkRojoConfig = checkRojoConfig;
//# sourceMappingURL=checkRojoConfig.js.map