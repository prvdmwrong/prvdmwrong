"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformLogical = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const assert_1 = require("../../Shared/util/assert");
const transformExpression_1 = require("./expressions/transformExpression");
const createTruthinessChecks_1 = require("../util/createTruthinessChecks");
const expressionChain_1 = require("../util/expressionChain");
const getKindName_1 = require("../util/getKindName");
const types_1 = require("../util/types");
const typescript_1 = __importDefault(require("typescript"));
function flattenByOperator(node, operatorKind) {
    const result = new Array();
    while (typescript_1.default.isBinaryExpression(node) && node.operatorToken.kind === operatorKind) {
        result.unshift(node.right);
        node = node.left;
    }
    result.unshift(node);
    return result;
}
function getLogicalChain(state, binaryExp, binaryOperatorKind, enableInlining) {
    return flattenByOperator(binaryExp, binaryOperatorKind).map((node, index, array) => {
        const type = state.getType(node);
        const [expression, statements] = state.capture(() => (0, transformExpression_1.transformExpression)(state, node));
        let inline = false;
        if (enableInlining) {
            const willWrap = index < array.length - 1 && (0, createTruthinessChecks_1.willCreateTruthinessChecks)(type);
            inline = luau_ast_1.default.list.isEmpty(statements) && !willWrap;
        }
        return { node, type, expression, statements, inline };
    });
}
function buildLogicalChainPrereqs(state, chain, conditionId, buildCondition, index = 0) {
    const expInfo = chain[index];
    state.prereqList(expInfo.statements);
    if (index === 0) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: conditionId,
            right: expInfo.expression,
        }));
    }
    else {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
            left: conditionId,
            operator: "=",
            right: expInfo.expression,
        }));
    }
    if (index + 1 < chain.length) {
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: buildCondition(conditionId, expInfo.node),
            statements: state.capturePrereqs(() => buildLogicalChainPrereqs(state, chain, conditionId, buildCondition, index + 1)),
            elseBody: luau_ast_1.default.list.make(),
        }));
    }
}
function mergeInlineExpressions(chain, binaryOperator) {
    for (let i = 0; i < chain.length; i++) {
        const info = chain[i];
        if (info.inline) {
            const exps = [info.expression];
            const j = i + 1;
            while (j < chain.length && chain[j].inline) {
                exps.push(chain[j].expression);
                chain.splice(j, 1);
            }
            info.expression = (0, expressionChain_1.binaryExpressionChain)(exps, binaryOperator);
        }
    }
}
function buildInlineConditionExpression(state, node, tsBinaryOperator, luaBinaryOperator, buildCondition) {
    const chain = getLogicalChain(state, node, tsBinaryOperator, true);
    mergeInlineExpressions(chain, luaBinaryOperator);
    if (chain.length === 1 && chain[0].inline) {
        return chain[0].expression;
    }
    const conditionId = luau_ast_1.default.tempId("condition");
    buildLogicalChainPrereqs(state, chain, conditionId, buildCondition);
    return conditionId;
}
function transformLogical(state, node) {
    if (node.operatorToken.kind === typescript_1.default.SyntaxKind.AmpersandAmpersandToken) {
        return buildInlineConditionExpression(state, node, node.operatorToken.kind, "and", (conditionId, node) => (0, createTruthinessChecks_1.createTruthinessChecks)(state, conditionId, node));
    }
    else if (node.operatorToken.kind === typescript_1.default.SyntaxKind.BarBarToken) {
        return buildInlineConditionExpression(state, node, node.operatorToken.kind, "or", (conditionId, node) => luau_ast_1.default.unary("not", (0, createTruthinessChecks_1.createTruthinessChecks)(state, conditionId, node)));
    }
    else if (node.operatorToken.kind === typescript_1.default.SyntaxKind.QuestionQuestionToken) {
        const conditionBuilder = (conditionId) => luau_ast_1.default.binary(conditionId, "==", luau_ast_1.default.nil());
        if (!(0, types_1.isPossiblyType)(state.getType(node), (0, types_1.isBooleanLiteralType)(state, false))) {
            return buildInlineConditionExpression(state, node, node.operatorToken.kind, "or", conditionBuilder);
        }
        const chain = getLogicalChain(state, node, typescript_1.default.SyntaxKind.QuestionQuestionToken, false);
        const conditionId = luau_ast_1.default.tempId("condition");
        buildLogicalChainPrereqs(state, chain, conditionId, conditionBuilder);
        return conditionId;
    }
    (0, assert_1.assert)(false, `Operator not implemented: ${(0, getKindName_1.getKindName)(node.operatorToken.kind)}`);
}
exports.transformLogical = transformLogical;
//# sourceMappingURL=transformLogical.js.map