"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformElementAccessExpression = exports.transformElementAccessExpressionInner = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const transformOptionalChain_1 = require("../transformOptionalChain");
const addIndexDiagnostics_1 = require("../../util/addIndexDiagnostics");
const addOneIfArrayType_1 = require("../../util/addOneIfArrayType");
const convertToIndexableExpression_1 = require("../../util/convertToIndexableExpression");
const getConstantValueLiteral_1 = require("../../util/getConstantValueLiteral");
const offset_1 = require("../../util/offset");
const traversal_1 = require("../../util/traversal");
const types_1 = require("../../util/types");
const validateNotAny_1 = require("../../util/validateNotAny");
const typescript_1 = __importDefault(require("typescript"));
function transformElementAccessExpressionInner(state, node, expression, argumentExpression) {
    (0, validateNotAny_1.validateNotAnyType)(state, node.expression);
    (0, validateNotAny_1.validateNotAnyType)(state, node.argumentExpression);
    const expType = state.typeChecker.getNonOptionalType(state.getType(node.expression));
    (0, addIndexDiagnostics_1.addIndexDiagnostics)(state, node, expType);
    const [index, prereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, argumentExpression));
    if (!luau_ast_1.default.list.isEmpty(prereqs)) {
        if ((0, types_1.isLuaTupleType)(state)(expType)) {
            expression = luau_ast_1.default.array([expression]);
        }
        expression = state.pushToVar(expression, "exp");
        state.prereqList(prereqs);
    }
    if (luau_ast_1.default.isCall(expression) && (0, types_1.isLuaTupleType)(state)(expType)) {
        if (!luau_ast_1.default.isNumberLiteral(index) || Number(index.value) !== 0) {
            expression = luau_ast_1.default.call(luau_ast_1.default.globals.select, [(0, offset_1.offset)(index, 1), expression]);
        }
        return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ParenthesizedExpression, { expression });
    }
    if (typescript_1.default.isDeleteExpression((0, traversal_1.skipUpwards)(node).parent)) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
                expression: (0, convertToIndexableExpression_1.convertToIndexableExpression)(expression),
                index: (0, addOneIfArrayType_1.addOneIfArrayType)(state, expType, index),
            }),
            operator: "=",
            right: luau_ast_1.default.nil(),
        }));
        return luau_ast_1.default.none();
    }
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ComputedIndexExpression, {
        expression: (0, convertToIndexableExpression_1.convertToIndexableExpression)(expression),
        index: (0, addOneIfArrayType_1.addOneIfArrayType)(state, expType, index),
    });
}
exports.transformElementAccessExpressionInner = transformElementAccessExpressionInner;
function transformElementAccessExpression(state, node) {
    const constantValue = (0, getConstantValueLiteral_1.getConstantValueLiteral)(state, node);
    if (constantValue) {
        return constantValue;
    }
    return (0, transformOptionalChain_1.transformOptionalChain)(state, node);
}
exports.transformElementAccessExpression = transformElementAccessExpression;
//# sourceMappingURL=transformElementAccessExpression.js.map