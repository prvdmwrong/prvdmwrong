"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.needsParentheses = void 0;
const LuauAST_1 = __importDefault(require("../../LuauAST"));
const assert_1 = require("../../LuauAST/util/assert");
const IF_EXPRESSION_PRECEDENCE = 1;
const UNARY_OPERATOR_PRECEDENCE = {
    not: 7,
    "#": 7,
    "-": 7,
};
const BINARY_OPERATOR_PRECEDENCE = {
    or: 1,
    and: 2,
    "<": 3,
    ">": 3,
    "<=": 3,
    ">=": 3,
    "~=": 3,
    "==": 3,
    "..": 4,
    "+": 5,
    "-": 5,
    "*": 6,
    "/": 6,
    "//": 6,
    "%": 6,
    "^": 8,
};
function getPrecedence(node) {
    if (LuauAST_1.default.isIfExpression(node)) {
        return IF_EXPRESSION_PRECEDENCE;
    }
    else if (LuauAST_1.default.isBinaryExpression(node)) {
        return BINARY_OPERATOR_PRECEDENCE[node.operator];
    }
    else if (LuauAST_1.default.isUnaryExpression(node)) {
        return UNARY_OPERATOR_PRECEDENCE[node.operator];
    }
    (0, assert_1.assert)(false);
}
function needsParentheses(node) {
    if (node.parent && LuauAST_1.default.isExpressionWithPrecedence(node.parent)) {
        const nodePrecedence = getPrecedence(node);
        const parentPrecedence = getPrecedence(node.parent);
        if (nodePrecedence < parentPrecedence) {
            return true;
        }
        else if (nodePrecedence === parentPrecedence) {
            return LuauAST_1.default.isBinaryExpression(node.parent) && node === node.parent.right;
        }
    }
    return false;
}
exports.needsParentheses = needsParentheses;
//# sourceMappingURL=needsParentheses.js.map