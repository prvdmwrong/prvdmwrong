"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateIdentifier = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
function validateIdentifier(state, node) {
    if (!luau_ast_1.default.isValidIdentifier(node.text)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noInvalidIdentifier(node));
    }
    else if (luau_ast_1.default.isReservedIdentifier(node.text)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noReservedIdentifier(node));
    }
}
exports.validateIdentifier = validateIdentifier;
//# sourceMappingURL=validateIdentifier.js.map