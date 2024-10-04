"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.offset = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
function getLiteralNumberValue(expression) {
    if (luau_ast_1.default.isNumberLiteral(expression)) {
        return Number(expression.value);
    }
    else if (luau_ast_1.default.isUnaryExpression(expression) && expression.operator === "-") {
        const innerValue = getLiteralNumberValue(expression.expression);
        if (innerValue !== undefined) {
            return -innerValue;
        }
    }
    return undefined;
}
function offset(expression, value) {
    if (value === 0) {
        return expression;
    }
    if (luau_ast_1.default.isBinaryExpression(expression) && (expression.operator === "+" || expression.operator === "-")) {
        const rightValue = getLiteralNumberValue(expression.right);
        if (rightValue !== undefined) {
            const newRightValue = rightValue + value * (expression.operator === "-" ? -1 : 1);
            if (newRightValue === 0) {
                return expression.left;
            }
            else {
                return luau_ast_1.default.binary(expression.left, expression.operator, luau_ast_1.default.number(newRightValue));
            }
        }
    }
    const literalValue = getLiteralNumberValue(expression);
    if (literalValue !== undefined) {
        return luau_ast_1.default.number(literalValue + value);
    }
    else {
        return luau_ast_1.default.binary(expression, value > 0 ? "+" : "-", luau_ast_1.default.number(Math.abs(value)));
    }
}
exports.offset = offset;
//# sourceMappingURL=offset.js.map