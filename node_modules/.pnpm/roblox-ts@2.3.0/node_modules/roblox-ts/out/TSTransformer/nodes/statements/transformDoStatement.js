"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformDoStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("../expressions/transformExpression");
const transformStatementList_1 = require("../transformStatementList");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const getStatements_1 = require("../../util/getStatements");
const typescript_1 = __importDefault(require("typescript"));
function transformDoStatement(state, { expression, statement }) {
    const statements = (0, transformStatementList_1.transformStatementList)(state, statement, (0, getStatements_1.getStatements)(statement));
    let conditionIsInvertedInLuau = true;
    if (typescript_1.default.isPrefixUnaryExpression(expression) && expression.operator === typescript_1.default.SyntaxKind.ExclamationToken) {
        expression = expression.operand;
        conditionIsInvertedInLuau = false;
    }
    const [condition, conditionPrereqs] = state.capture(() => (0, createTruthinessChecks_1.createTruthinessChecks)(state, (0, transformExpression_1.transformExpression)(state, expression), expression));
    const repeatStatements = luau_ast_1.default.list.make();
    luau_ast_1.default.list.push(repeatStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.DoStatement, {
        statements,
    }));
    luau_ast_1.default.list.pushList(repeatStatements, conditionPrereqs);
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.RepeatStatement, {
        statements: repeatStatements,
        condition: conditionIsInvertedInLuau ? luau_ast_1.default.unary("not", condition) : condition,
    }));
}
exports.transformDoStatement = transformDoStatement;
//# sourceMappingURL=transformDoStatement.js.map