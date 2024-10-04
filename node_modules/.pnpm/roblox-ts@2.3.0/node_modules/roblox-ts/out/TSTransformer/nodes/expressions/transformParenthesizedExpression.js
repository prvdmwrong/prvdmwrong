"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformParenthesizedExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const transformExpression_1 = require("./transformExpression");
const traversal_1 = require("../../util/traversal");
function transformParenthesizedExpression(state, node) {
    const expression = (0, transformExpression_1.transformExpression)(state, (0, traversal_1.skipDownwards)(node.expression));
    if (luau_ast_1.default.isSimple(expression)) {
        return expression;
    }
    else {
        return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ParenthesizedExpression, { expression });
    }
}
exports.transformParenthesizedExpression = transformParenthesizedExpression;
//# sourceMappingURL=transformParenthesizedExpression.js.map