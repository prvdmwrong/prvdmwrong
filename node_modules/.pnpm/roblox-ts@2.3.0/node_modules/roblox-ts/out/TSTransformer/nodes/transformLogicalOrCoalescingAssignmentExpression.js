"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformLogicalOrCoalescingAssignmentExpressionStatement = exports.transformLogicalOrCoalescingAssignmentExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./expressions/transformExpression");
const transformWritable_1 = require("./transformWritable");
const createTruthinessChecks_1 = require("../util/createTruthinessChecks");
const typescript_1 = __importDefault(require("typescript"));
function transformCoalescingAssignmentExpression(state, left, right) {
    const writable = (0, transformWritable_1.transformWritableExpression)(state, left, true);
    const [value, valuePreqreqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, right));
    const ifStatements = luau_ast_1.default.list.make();
    luau_ast_1.default.list.pushList(ifStatements, valuePreqreqs);
    luau_ast_1.default.list.push(ifStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writable,
        operator: "=",
        right: value,
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: luau_ast_1.default.binary(writable, "==", luau_ast_1.default.nil()),
        statements: ifStatements,
        elseBody: luau_ast_1.default.list.make(),
    }));
    return writable;
}
function transformLogicalAndAssignmentExpression(state, left, right) {
    const writable = (0, transformWritable_1.transformWritableExpression)(state, left, true);
    const [value, valuePreqreqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, right));
    const conditionId = state.pushToVar(writable, "condition");
    const ifStatements = luau_ast_1.default.list.make();
    luau_ast_1.default.list.pushList(ifStatements, valuePreqreqs);
    luau_ast_1.default.list.push(ifStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: conditionId,
        operator: "=",
        right: value,
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: (0, createTruthinessChecks_1.createTruthinessChecks)(state, writable, left),
        statements: ifStatements,
        elseBody: luau_ast_1.default.list.make(),
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writable,
        operator: "=",
        right: conditionId,
    }));
    return writable;
}
function transformLogicalOrAssignmentExpression(state, left, right) {
    const writable = (0, transformWritable_1.transformWritableExpression)(state, left, true);
    const [value, valuePreqreqs] = state.capture(() => (0, transformExpression_1.transformExpression)(state, right));
    const conditionId = state.pushToVar(writable, "condition");
    const ifStatements = luau_ast_1.default.list.make();
    luau_ast_1.default.list.pushList(ifStatements, valuePreqreqs);
    luau_ast_1.default.list.push(ifStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: conditionId,
        operator: "=",
        right: value,
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition: luau_ast_1.default.unary("not", (0, createTruthinessChecks_1.createTruthinessChecks)(state, writable, left)),
        statements: ifStatements,
        elseBody: luau_ast_1.default.list.make(),
    }));
    state.prereq(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Assignment, {
        left: writable,
        operator: "=",
        right: conditionId,
    }));
    return writable;
}
function transformLogicalOrCoalescingAssignmentExpression(state, node) {
    const operator = node.operatorToken.kind;
    if (operator === typescript_1.default.SyntaxKind.QuestionQuestionEqualsToken) {
        return transformCoalescingAssignmentExpression(state, node.left, node.right);
    }
    else if (operator === typescript_1.default.SyntaxKind.AmpersandAmpersandEqualsToken) {
        return transformLogicalAndAssignmentExpression(state, node.left, node.right);
    }
    else {
        return transformLogicalOrAssignmentExpression(state, node.left, node.right);
    }
}
exports.transformLogicalOrCoalescingAssignmentExpression = transformLogicalOrCoalescingAssignmentExpression;
function transformLogicalOrCoalescingAssignmentExpressionStatement(state, node) {
    return state.capturePrereqs(() => transformLogicalOrCoalescingAssignmentExpression(state, node));
}
exports.transformLogicalOrCoalescingAssignmentExpressionStatement = transformLogicalOrCoalescingAssignmentExpressionStatement;
//# sourceMappingURL=transformLogicalOrCoalescingAssignmentExpression.js.map