"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createTruthinessChecks = exports.willCreateTruthinessChecks = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../Shared/diagnostics");
const DiagnosticService_1 = require("../classes/DiagnosticService");
const expressionChain_1 = require("./expressionChain");
const types_1 = require("./types");
function willCreateTruthinessChecks(type) {
    return ((0, types_1.isPossiblyType)(type, (0, types_1.isNumberLiteralType)(0)) ||
        (0, types_1.isPossiblyType)(type, types_1.isNaNType) ||
        (0, types_1.isPossiblyType)(type, types_1.isEmptyStringType));
}
exports.willCreateTruthinessChecks = willCreateTruthinessChecks;
function createTruthinessChecks(state, exp, node) {
    const type = state.getType(node);
    const isAssignableToZero = (0, types_1.isPossiblyType)(type, (0, types_1.isNumberLiteralType)(0));
    const isAssignableToNaN = (0, types_1.isPossiblyType)(type, types_1.isNaNType);
    const isAssignableToEmptyString = (0, types_1.isPossiblyType)(type, types_1.isEmptyStringType);
    if (isAssignableToZero || isAssignableToNaN || isAssignableToEmptyString) {
        exp = state.pushToVarIfComplex(exp, "value");
    }
    const checks = new Array();
    if (isAssignableToZero) {
        checks.push(luau_ast_1.default.binary(exp, "~=", luau_ast_1.default.number(0)));
    }
    if (isAssignableToZero || isAssignableToNaN) {
        checks.push(luau_ast_1.default.binary(exp, "==", exp));
    }
    if (isAssignableToEmptyString) {
        checks.push(luau_ast_1.default.binary(exp, "~=", luau_ast_1.default.string("")));
    }
    checks.push(exp);
    if (state.data.projectOptions.logTruthyChanges &&
        (isAssignableToZero || isAssignableToNaN || isAssignableToEmptyString)) {
        const checkStrs = new Array();
        if (isAssignableToZero)
            checkStrs.push("0");
        if (isAssignableToZero || isAssignableToNaN)
            checkStrs.push("NaN");
        if (isAssignableToEmptyString)
            checkStrs.push('""');
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.warnings.truthyChange(checkStrs.join(", "))(node));
    }
    return (0, expressionChain_1.binaryExpressionChain)(checks, "and");
}
exports.createTruthinessChecks = createTruthinessChecks;
//# sourceMappingURL=createTruthinessChecks.js.map