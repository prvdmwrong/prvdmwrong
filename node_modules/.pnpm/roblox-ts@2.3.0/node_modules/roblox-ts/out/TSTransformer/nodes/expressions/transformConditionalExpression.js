"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformConditionalExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const isUsedAsStatement_1 = require("../../util/isUsedAsStatement");
const wrapExpressionStatement_1 = require("../../util/wrapExpressionStatement");
function transformConditionalExpression(state, node) {
    const condition = (0, transformExpression_1.transformExpression)(state, node.condition);
    const [whenTrue, whenTruePrereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, node.whenTrue));
    const [whenFalse, whenFalsePrereqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, node.whenFalse));
    if ((0, isUsedAsStatement_1.isUsedAsStatement)(node)) {
        luau_ast_1.default.list.pushList(whenTruePrereqs, (0, wrapExpressionStatement_1.wrapExpressionStatement)(whenTrue));
        luau_ast_1.default.list.pushList(whenFalsePrereqs, (0, wrapExpressionStatement_1.wrapExpressionStatement)(whenFalse));
        state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: (0, createTruthinessChecks_1.createTruthinessChecks)(state, condition, node.condition),
            statements: whenTruePrereqs,
            elseBody: whenFalsePrereqs,
        }));
        return luau_ast_1.default.none();
    }
    if (luau_ast_1.default.list.isEmpty(whenTruePrereqs) && luau_ast_1.default.list.isEmpty(whenFalsePrereqs)) {
        return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfExpression, {
            condition: (0, createTruthinessChecks_1.createTruthinessChecks)(state, condition, node.condition),
            expression: whenTrue,
            alternative: whenFalse,
        });
    }
    const tempId = luau_ast_1.default.tempId("result");
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
        left: tempId,
        right: undefined,
    }));
    luau_ast_1.default.list.push(whenTruePrereqs, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: tempId,
        operator: "=",
        right: whenTrue,
    }));
    luau_ast_1.default.list.push(whenFalsePrereqs, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: tempId,
        operator: "=",
        right: whenFalse,
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: (0, createTruthinessChecks_1.createTruthinessChecks)(state, condition, node.condition),
        statements: whenTruePrereqs,
        elseBody: whenFalsePrereqs,
    }));
    return tempId;
}
exports.transformConditionalExpression = transformConditionalExpression;
//# sourceMappingURL=transformConditionalExpression.js.map