"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.valueToIdStr = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function expressionToStr(expression) {
    if (luau_ast_1.default.isIdentifier(expression) ||
        luau_ast_1.default.isPropertyAccessExpression(expression)) {
        return expression.name;
    }
    if (luau_ast_1.default.isCallExpression(expression)) {
        if (luau_ast_1.default.isPropertyAccessExpression(expression.expression) && expression.expression.name === "new") {
            return expressionToStr(expression.expression.expression);
        }
    }
}
function uncapitalizeFirstLetter(str) {
    return str.charAt(0).toLowerCase() + str.slice(1);
}
function valueToIdStr(value) {
    const valueStr = expressionToStr(value);
    if (valueStr !== undefined && luau_ast_1.default.isValidIdentifier(valueStr)) {
        return uncapitalizeFirstLetter(valueStr);
    }
    return "";
}
exports.valueToIdStr = valueToIdStr;
//# sourceMappingURL=valueToIdStr.js.map