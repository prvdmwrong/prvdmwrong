"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.wrapExpressionStatement = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function wrapExpressionStatement(node) {
    if (luau_ast_1.default.isTemporaryIdentifier(node) || luau_ast_1.default.isNone(node)) {
        return luau_ast_1.default.list.make();
    }
    else if (luau_ast_1.default.isCall(node)) {
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.CallStatement, { expression: node }));
    }
    else {
        return luau_ast_1.default.list.make(luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.VariableDeclaration, {
            left: luau_ast_1.default.tempId(),
            right: node,
        }));
    }
}
exports.wrapExpressionStatement = wrapExpressionStatement;
//# sourceMappingURL=wrapExpressionStatement.js.map