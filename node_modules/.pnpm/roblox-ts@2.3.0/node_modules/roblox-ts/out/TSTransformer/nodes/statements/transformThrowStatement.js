"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformThrowStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("../expressions/transformExpression");
function transformThrowStatement(state, node) {
    const args = new Array();
    if (node.expression !== undefined) {
        args.push((0, transformExpression_1.transformExpression)(state, node.expression));
    }
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, {
        expression: luau_ast_1.default.call(luau_ast_1.default.globals.error, args),
    }));
}
exports.transformThrowStatement = transformThrowStatement;
//# sourceMappingURL=transformThrowStatement.js.map