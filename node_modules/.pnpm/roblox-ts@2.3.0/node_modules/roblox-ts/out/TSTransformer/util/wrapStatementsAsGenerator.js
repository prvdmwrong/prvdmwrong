"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.wrapStatementsAsGenerator = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function wrapStatementsAsGenerator(state, node, statements) {
    return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ReturnStatement, {
        expression: luau_ast_1.default.call(state.TS(node, "generator"), [
            luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FunctionExpression, {
                hasDotDotDot: false,
                parameters: luau_ast_1.default.list.make(),
                statements,
            }),
        ]),
    }));
}
exports.wrapStatementsAsGenerator = wrapStatementsAsGenerator;
//# sourceMappingURL=wrapStatementsAsGenerator.js.map