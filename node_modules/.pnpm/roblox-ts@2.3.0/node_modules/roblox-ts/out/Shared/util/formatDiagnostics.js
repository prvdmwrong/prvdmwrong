"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.formatDiagnostics = void 0;
const os_1 = require("os");
const typescript_1 = __importDefault(require("typescript"));
function createFormatDiagnosticsHost() {
    return {
        getCurrentDirectory: () => process.cwd(),
        getCanonicalFileName: fileName => fileName,
        getNewLine: () => os_1.EOL,
    };
}
function formatDiagnostics(diagnostics) {
    return typescript_1.default.formatDiagnosticsWithColorAndContext(diagnostics, createFormatDiagnosticsHost());
}
exports.formatDiagnostics = formatDiagnostics;
//# sourceMappingURL=formatDiagnostics.js.map