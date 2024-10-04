"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformWhileStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("../expressions/transformExpression");
const transformStatementList_1 = require("../transformStatementList");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const getStatements_1 = require("../../util/getStatements");
function transformWhileStatement(state, node) {
    const whileStatements = luau_ast_1.default.list.make();
    let [conditionExp, conditionPrereqs] = state.capture(() => (0, createTruthinessChecks_1.createTruthinessChecks)(state, (0, transformExpression_1.transformExpression)(state, node.expression), node.expression));
    if (!luau_ast_1.default.list.isEmpty(conditionPrereqs)) {
        luau_ast_1.default.list.pushList(whileStatements, conditionPrereqs);
        luau_ast_1.default.list.push(whileStatements, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
            condition: luau_ast_1.default.unary("not", conditionExp),
            statements: luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.BreakStatement, {})),
            elseBody: luau_ast_1.default.list.make(),
        }));
        conditionExp = luau_ast_1.default.bool(true);
    }
    luau_ast_1.default.list.pushList(whileStatements, (0, transformStatementList_1.transformStatementList)(state, node.statement, (0, getStatements_1.getStatements)(node.statement)));
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.WhileStatement, {
        condition: conditionExp,
        statements: whileStatements,
    }));
}
exports.transformWhileStatement = transformWhileStatement;
//# sourceMappingURL=transformWhileStatement.js.map