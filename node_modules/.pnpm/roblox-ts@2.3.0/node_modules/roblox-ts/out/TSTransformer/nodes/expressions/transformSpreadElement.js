"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformSpreadElement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const diagnostics_1 = require("../../../Shared/diagnostics");
const assert_1 = require("../../../Shared/util/assert");
const DiagnosticService_1 = require("../../classes/DiagnosticService");
const transformExpression_1 = require("./transformExpression");
const getAddIterableToArrayBuilder_1 = require("../../util/getAddIterableToArrayBuilder");
const types_1 = require("../../util/types");
const validateNotAny_1 = require("../../util/validateNotAny");
const typescript_1 = __importDefault(require("typescript"));
function transformSpreadElement(state, node) {
    (0, validateNotAny_1.validateNotAnyType)(state, node.expression);
    (0, assert_1.assert)(!typescript_1.default.isArrayLiteralExpression(node.parent) && node.parent.arguments);
    if (node.parent.arguments[node.parent.arguments.length - 1] !== node) {
        DiagnosticService_1.DiagnosticService.addDiagnostic(diagnostics_1.errors.noPrecedingSpreadElement(node));
    }
    const expression = (0, transformExpression_1.transformExpression)(state, node.expression);
    const type = state.getType(node.expression);
    if ((0, types_1.isDefinitelyType)(type, (0, types_1.isArrayType)(state))) {
        return luau_ast_1.default.call(luau_ast_1.default.globals.unpack, [expression]);
    }
    else {
        const addIterableToArrayBuilder = (0, getAddIterableToArrayBuilder_1.getAddIterableToArrayBuilder)(state, node.expression, type);
        const arrayId = state.pushToVar(luau_ast_1.default.array(), "array");
        const lengthId = state.pushToVar(luau_ast_1.default.number(0), "length");
        state.prereqList(addIterableToArrayBuilder(state, expression, arrayId, lengthId, 0, false));
        return luau_ast_1.default.call(luau_ast_1.default.globals.unpack, [arrayId]);
    }
}
exports.transformSpreadElement = transformSpreadElement;
//# sourceMappingURL=transformSpreadElement.js.map