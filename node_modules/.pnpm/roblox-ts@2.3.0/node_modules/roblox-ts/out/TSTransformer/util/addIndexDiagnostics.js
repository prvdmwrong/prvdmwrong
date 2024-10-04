"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.addIndexDiagnostics = void 0;
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const isMethod_1 = require("./isMethod");
const isValidMethodIndexWithoutCall_1 = require("./isValidMethodIndexWithoutCall");
const traversal_1 = require("./traversal");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
function addIndexDiagnostics(state, node, expType) {
    const symbol = (0, types_1.getFirstDefinedSymbol)(state, expType);
    if ((symbol && state.services.macroManager.getPropertyCallMacro(symbol)) ||
        (!(0, isValidMethodIndexWithoutCall_1.isValidMethodIndexWithoutCall)(state, (0, traversal_1.skipUpwards)(node)) && (0, isMethod_1.isMethod)(state, node))) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noIndexWithoutCall(node));
    }
    if (typescript_1.default.isPrototypeAccess(node)) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPrototype(node));
    }
}
exports.addIndexDiagnostics = addIndexDiagnostics;
//# sourceMappingURL=addIndexDiagnostics.js.map