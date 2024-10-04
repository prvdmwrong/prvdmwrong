"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.convertToIndexableExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function convertToIndexableExpression(expression) {
    if (luau_ast_1.default.isIndexableExpression(expression)) {
        return expression;
    }
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.ParenthesizedExpression, { expression });
}
exports.convertToIndexableExpression = convertToIndexableExpression;
//# sourceMappingURL=convertToIndexableExpression.js.map