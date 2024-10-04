"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformExpressionStatement = exports.transformExpressionStatementInner = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("../expressions/transformExpression");
const transformLogicalOrCoalescingAssignmentExpression_1 = require("../transformLogicalOrCoalescingAssignmentExpression");
const transformWritable_1 = require("../transformWritable");
const typeGuards_1 = require("../../typeGuards");
const assignment_1 = require("../../util/assignment");
const getAssignableValue_1 = require("../../util/getAssignableValue");
const traversal_1 = require("../../util/traversal");
const wrapExpressionStatement_1 = require("../../util/wrapExpressionStatement");
const typescript_1 = __importDefault(require("typescript"));
function transformUnaryExpressionStatement(state, node) {
    const writable = (0, transformWritable_1.transformWritableExpression)(state, node.operand, false);
    const operator = node.operator === typescript_1.default.SyntaxKind.PlusPlusToken ? "+=" : "-=";
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writable,
        operator,
        right: luau_ast_1.default.number(1),
    });
}
function transformExpressionStatementInner(state, expression) {
    if (typescript_1.default.isBinaryExpression(expression)) {
        const operatorKind = expression.operatorToken.kind;
        if (typescript_1.default.isLogicalOrCoalescingAssignmentExpression(expression)) {
            return (0, transformLogicalOrCoalescingAssignmentExpression_1.transformLogicalOrCoalescingAssignmentExpressionStatement)(state, expression);
        }
        else if (typescript_1.default.isAssignmentOperator(operatorKind) &&
            !typescript_1.default.isArrayLiteralExpression(expression.left) &&
            !typescript_1.default.isObjectLiteralExpression(expression.left)) {
            const writableType = state.getType(expression.left);
            const valueType = state.getType(expression.right);
            const operator = (0, assignment_1.getSimpleAssignmentOperator)(writableType, operatorKind, valueType);
            const { writable, readable, value } = (0, transformWritable_1.transformWritableAssignment)(state, expression.left, expression.right, operator === undefined, operator === undefined);
            if (operator !== undefined) {
                return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
                    left: writable,
                    operator,
                    right: (0, getAssignableValue_1.getAssignableValue)(operator, value, valueType),
                }));
            }
            else {
                return luau_ast_1.default.list.make((0, assignment_1.createCompoundAssignmentStatement)(state, expression, writable, writableType, readable, operatorKind, value, valueType));
            }
        }
    }
    else if ((typescript_1.default.isPrefixUnaryExpression(expression) || typescript_1.default.isPostfixUnaryExpression(expression)) &&
        (0, typeGuards_1.isUnaryAssignmentOperator)(expression.operator)) {
        return luau_ast_1.default.list.make(transformUnaryExpressionStatement(state, expression));
    }
    return (0, wrapExpressionStatement_1.wrapExpressionStatement)((0, transformExpression_1.transformExpression)(state, expression));
}
exports.transformExpressionStatementInner = transformExpressionStatementInner;
function transformExpressionStatement(state, node) {
    const expression = (0, traversal_1.skipDownwards)(node.expression);
    return transformExpressionStatementInner(state, expression);
}
exports.transformExpressionStatement = transformExpressionStatement;
//# sourceMappingURL=transformExpressionStatement.js.map