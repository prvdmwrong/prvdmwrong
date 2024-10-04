"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.checkFileName = void 0;
const path_1 = __importDefault(require("path"));
const constants_1 = require("../../Shared/constants");
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../../TSTransformer/classes/DiagnosticService");
function checkFileName(filePath) {
    const baseName = path_1.default.basename(filePath);
    const nameWarning = constants_1.FILENAME_WARNINGS.get(baseName);
    if (nameWarning) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.incorrectFileName(baseName, nameWarning, filePath));
    }
}
exports.checkFileName = checkFileName;
//# sourceMappingURL=checkFileName.js.map