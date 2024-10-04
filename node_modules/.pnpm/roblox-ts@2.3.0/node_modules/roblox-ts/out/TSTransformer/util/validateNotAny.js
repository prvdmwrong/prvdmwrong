"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateNotAnyType = void 0;
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const getOriginalSymbolOfNode_1 = require("./getOriginalSymbolOfNode");
const traversal_1 = require("./traversal");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
function validateNotAnyType(state, node) {
    if (typescript_1.default.isSpreadElement(node)) {
        node = (0, traversal_1.skipDownwards)(node.expression);
    }
    let type = state.getType(node);
    if ((0, types_1.isDefinitelyType)(type, (0, types_1.isArrayType)(state))) {
        const indexType = state.typeChecker.getIndexTypeOfType(type, typescript_1.default.IndexKind.Number);
        if (indexType) {
            type = indexType;
        }
    }
    if ((0, types_1.isDefinitelyType)(type, (0, types_1.isAnyType)(state))) {
        const symbol = (0, getOriginalSymbolOfNode_1.getOriginalSymbolOfNode)(state.typeChecker, node);
        if (symbol) {
            if (!state.multiTransformState.isReportedByNoAnyCache.has(symbol)) {
                state.multiTransformState.isReportedByNoAnyCache.add(symbol);
                DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noAny(node));
            }
        }
        else {
            DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noAny(node));
        }
    }
}
exports.validateNotAnyType = validateNotAnyType;
//# sourceMappingURL=validateNotAny.js.map