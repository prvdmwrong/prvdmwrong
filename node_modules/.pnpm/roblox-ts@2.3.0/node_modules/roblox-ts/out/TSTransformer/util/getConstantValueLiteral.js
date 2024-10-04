"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getConstantValueLiteral = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function getConstantValueLiteral(state, node) {
    const constantValue = state.typeChecker.getConstantValue(node);
    if (constantValue !== undefined) {
        if (typeof constantValue === "string") {
            return luau_ast_1.default.string(constantValue);
        }
        else {
            return luau_ast_1.default.number(constantValue);
        }
    }
}
exports.getConstantValueLiteral = getConstantValueLiteral;
//# sourceMappingURL=getConstantValueLiteral.js.map