"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformVoidExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpressionStatement_1 = require("../statements/transformExpressionStatement");
const traversal_1 = require("../../util/traversal");
function transformVoidExpression(state, node) {
    state.prereqList((0, transformExpressionStatement_1.transformExpressionStatementInner)(state, (0, traversal_1.skipDownwards)(node.expression)));
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.NilLiteral, {});
}
exports.transformVoidExpression = transformVoidExpression;
//# sourceMappingURL=transformVoidExpression.js.map