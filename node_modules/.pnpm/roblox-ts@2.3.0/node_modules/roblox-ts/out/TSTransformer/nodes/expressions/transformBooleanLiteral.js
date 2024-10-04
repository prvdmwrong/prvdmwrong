"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformFalseKeyword = exports.transformTrueKeyword = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function transformTrueKeyword() {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.TrueLiteral, {});
}
exports.transformTrueKeyword = transformTrueKeyword;
function transformFalseKeyword() {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.FalseLiteral, {});
}
exports.transformFalseKeyword = transformFalseKeyword;
//# sourceMappingURL=transformBooleanLiteral.js.map