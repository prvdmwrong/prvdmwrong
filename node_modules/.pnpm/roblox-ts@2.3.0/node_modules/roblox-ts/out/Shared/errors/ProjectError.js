"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProjectError = void 0;
const DiagnosticError_1 = require("./DiagnosticError");
const createTextDiagnostic_1 = require("../util/createTextDiagnostic");
class ProjectError extends DiagnosticError_1.DiagnosticError {
    constructor(message) {
        super([(0, createTextDiagnostic_1.createTextDiagnostic)(message)]);
    }
}
exports.ProjectError = ProjectError;
//# sourceMappingURL=ProjectError.js.map