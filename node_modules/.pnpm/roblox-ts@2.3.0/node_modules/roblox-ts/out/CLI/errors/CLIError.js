"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CLIError = void 0;
const DiagnosticError_1 = require("../../Shared/errors/DiagnosticError");
const createTextDiagnostic_1 = require("../../Shared/util/createTextDiagnostic");
class CLIError extends DiagnosticError_1.DiagnosticError {
    constructor(message) {
        super([(0, createTextDiagnostic_1.createTextDiagnostic)(message)]);
    }
}
exports.CLIError = CLIError;
//# sourceMappingURL=CLIError.js.map