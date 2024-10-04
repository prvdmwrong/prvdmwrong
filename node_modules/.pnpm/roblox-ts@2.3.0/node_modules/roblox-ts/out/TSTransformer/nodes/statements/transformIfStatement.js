"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformIfStatement = exports.transformIfStatementInner = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("../expressions/transformExpression");
const transformStatementList_1 = require("../transformStatementList");
const createTruthinessChecks_1 = require("../../util/createTruthinessChecks");
const getStatements_1 = require("../../util/getStatements");
const typescript_1 = __importDefault(require("typescript"));
function transformIfStatementInner(state, node) {
    const condition = (0, createTruthinessChecks_1.createTruthinessChecks)(state, (0, transformExpression_1.transformExpression)(state, node.expression), node.expression);
    const statements = (0, transformStatementList_1.transformStatementList)(state, node.thenStatement, (0, getStatements_1.getStatements)(node.thenStatement));
    const elseStatement = node.elseStatement;
    let elseBody;
    if (elseStatement === undefined) {
        elseBody = luau_ast_1.default.list.make();
    }
    else if (typescript_1.default.isIfStatement(elseStatement)) {
        const [elseIf, elseIfPrereqs] = state.capture(() => transformIfStatementInner(state, elseStatement));
        if (luau_ast_1.default.list.isEmpty(elseIfPrereqs)) {
            elseBody = elseIf;
        }
        else {
            const elseIfStatements = luau_ast_1.default.list.make();
            luau_ast_1.default.list.pushList(elseIfStatements, elseIfPrereqs);
            luau_ast_1.default.list.push(elseIfStatements, elseIf);
            elseBody = elseIfStatements;
        }
    }
    else {
        elseBody = (0, transformStatementList_1.transformStatementList)(state, elseStatement, (0, getStatements_1.getStatements)(elseStatement));
    }
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.IfStatement, {
        condition,
        statements,
        elseBody,
    });
}
exports.transformIfStatementInner = transformIfStatementInner;
function transformIfStatement(state, node) {
    return luau_ast_1.default.list.make(transformIfStatementInner(state, node));
}
exports.transformIfStatement = transformIfStatement;
//# sourceMappingURL=transformIfStatement.js.map