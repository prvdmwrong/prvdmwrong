"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DiagnosticError = void 0;
const LoggableError_1 = require("./LoggableError");
const formatDiagnostics_1 = require("../util/formatDiagnostics");
class DiagnosticError extends LoggableError_1.LoggableError {
    constructor(diagnostics) {
        super();
        this.diagnostics = diagnostics;
    }
    toString() {
        return (0, formatDiagnostics_1.formatDiagnostics)(this.diagnostics);
    }
}
exports.DiagnosticError = DiagnosticError;
//# sourceMappingURL=DiagnosticError.js.map