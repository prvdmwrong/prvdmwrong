"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformReturnStatement = exports.transformReturnStatementInner = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const TSTransformer_1 = require("../..");
const transformExpression_1 = require("../expressions/transformExpression");
const ensureTransformOrder_1 = require("../../util/ensureTransformOrder");
const isBlockedByTryStatement_1 = require("../../util/isBlockedByTryStatement");
const traversal_1 = require("../../util/traversal");
const types_1 = require("../../util/types");
const typescript_1 = __importDefault(require("typescript"));
function isTupleReturningCall(state, tsExpression, luaExpression) {
    return (luau_ast_1.default.isCall(luaExpression) &&
        (0, types_1.isLuaTupleType)(state)(state.typeChecker.getTypeAtLocation((0, traversal_1.skipDownwards)(tsExpression))));
}
function isTupleMacro(state, expression) {
    if (typescript_1.default.isCallExpression(expression)) {
        const symbol = (0, types_1.getFirstDefinedSymbol)(state, state.getType(expression.expression));
        if (symbol && symbol === state.services.macroManager.getSymbolOrThrow(TSTransformer_1.SYMBOL_NAMES.$tuple)) {
            return true;
        }
    }
    return false;
}
function transformReturnStatementInner(state, returnExp) {
    const result = luau_ast_1.default.list.make();
    let expression;
    if (typescript_1.default.isCallExpression(returnExp) && isTupleMacro(state, returnExp)) {
        const [args, prereqs] = state.capture(() => (0, ensureTransformOrder_1.ensureTransformOrder)(state, returnExp.arguments));
        luau_ast_1.default.list.pushList(result, prereqs);
        expression = luau_ast_1.default.list.make(...args);
    }
    else {
        expression = (0, transformExpression_1.transformExpression)(state, (0, traversal_1.skipDownwards)(returnExp));
        if ((0, types_1.isLuaTupleType)(state)(state.getType(returnExp)) && !isTupleReturningCall(state, returnExp, expression)) {
            if (luau_ast_1.default.isArray(expression)) {
                expression = expression.members;
            }
            else {
                expression = luau_ast_1.default.call(luau_ast_1.default.globals.unpack, [expression]);
            }
        }
    }
    if ((0, isBlockedByTryStatement_1.isReturnBlockedByTryStatement)(returnExp)) {
        state.markTryUses("usesReturn");
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
            expression: luau_ast_1.default.list.make(state.TS(returnExp, "TRY_RETURN"), luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.Array, {
                members: luau_ast_1.default.list.isList(expression) ? expression : luau_ast_1.default.list.make(expression),
            })),
        }));
    }
    else {
        luau_ast_1.default.list.push(result, luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, { expression }));
    }
    return result;
}
exports.transformReturnStatementInner = transformReturnStatementInner;
function transformReturnStatement(state, node) {
    if (!node.expression) {
        if ((0, isBlockedByTryStatement_1.isReturnBlockedByTryStatement)(node)) {
            state.markTryUses("usesReturn");
            return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
                expression: luau_ast_1.default.list.make(state.TS(node, "TRY_RETURN"), luau_ast_1.default.array()),
            }));
        }
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, { expression: luau_ast_1.default.nil() }));
    }
    return transformReturnStatementInner(state, node.expression);
}
exports.transformReturnStatement = transformReturnStatement;
//# sourceMappingURL=transformReturnStatement.js.map