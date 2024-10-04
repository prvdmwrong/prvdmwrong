"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.transformOmittedExpression = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function transformOmittedExpression() {
    return luau_ast_1.default.nil();
}
exports.transformOmittedExpression = transformOmittedExpression;
//# sourceMappingURL=transformOmittedExpression.js.map