"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.propertyAccessExpressionChain = exports.binaryExpressionChain = void 0;
const luau_ast_1 = __importDefault(require("@roblox-ts/luau-ast"));
const convertToIndexableExpression_1 = require("./convertToIndexableExpression");
function binaryExpressionChain(expressions, operator) {
    return expressions.reduce((acc, current) => luau_ast_1.default.binary(acc, operator, current));
}
exports.binaryExpressionChain = binaryExpressionChain;
function propertyAccessExpressionChain(expression, names) {
    return names.reduce((acc, current) => luau_ast_1.default.property(acc, current), (0, convertToIndexableExpression_1.convertToIndexableExpression)(expression));
}
exports.propertyAccessExpressionChain = propertyAccessExpressionChain;
//# sourceMappingURL=expressionChain.js.map