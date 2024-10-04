"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformNumericLiteral = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function transformNumericLiteral(state, node) {
    return luau_ast_1.default.create(luau_ast_1.default.SyntaxKind.NumberLiteral, {
        value: node.getText(),
    });
}
exports.transformNumericLiteral = transformNumericLiteral;
//# sourceMappingURL=transformNumericLiteral.js.map