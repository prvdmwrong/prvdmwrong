"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.isValidMethodIndexWithoutCall = void 0;
const callMacros_1 = require("../macros/callMacros");
const types_1 = require("./types");
const typescript_1 = __importDefault(require("typescript"));
function isValidMethodIndexWithoutCall(state, node) {
    const { parent } = node;
    if (typescript_1.default.isBinaryExpression(parent)) {
        return true;
    }
    if (typescript_1.default.isPrefixUnaryExpression(parent)) {
        return true;
    }
    if (typescript_1.default.isCallExpression(parent)) {
        const expType = state.typeChecker.getNonOptionalType(state.getType(parent.expression));
        const symbol = (0, types_1.getFirstDefinedSymbol)(state, expType);
        if (symbol) {
            const macro = state.services.macroManager.getCallMacro(symbol);
            if (macro === callMacros_1.CALL_MACROS.typeIs ||
                macro === callMacros_1.CALL_MACROS.typeOf) {
                return true;
            }
        }
    }
    return false;
}
exports.isValidMethodIndexWithoutCall = isValidMethodIndexWithoutCall;
//# sourceMappingURL=isValidMethodIndexWithoutCall.js.map